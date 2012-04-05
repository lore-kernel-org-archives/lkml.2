Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2DEQn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:43:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51150 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2DEQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:43:28 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Mel Gorman <mgorman@suse.de>, "riel@redhat.com\"" <riel@redhat.com>
Subject: [PATCH 0/2] Documentation: mm: Add missing compact_node in vm.txt 
Date: Fri,  6 Apr 2012 01:42:29 +0900
Message-Id: <1333644149-31247-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch add missing compact_node in vm.txt.
2nd patch correct a path to extfrag_index.

Cc: Mel Gorman <mgorman@suse.de>
Cc: riel@redhat.com" <riel@redhat.com>


Masanari Iida (2):
  Documentation: mm: Add compact_node in Documentation/sysctl/vm.txt
  Documentation: mm: Fix path to extfrag_index in vm.txt

 Documentation/sysctl/vm.txt |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

-- 
1.7.10.rc4

