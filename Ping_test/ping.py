#!/usr/bin/env python3

class ping:
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __init__(self):
        self.resultList_array = []

    def add_to_list(self, *items):

        self.resultList_array.append(list(items))
        return self.resultList_array
