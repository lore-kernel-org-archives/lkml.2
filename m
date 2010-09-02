Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0IBN74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:59:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33713 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab0IBN7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:59:51 -0400
From: Eric B Munson <emunson@mgebm.net>
To: akpm@linux-foundation.org
Cc: mingo@redhat.com, hugh.dickins@tiscali.co.uk, riel@redhat.com,
        peterz@infradead.org, anton@samba.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@jp.fujitsu.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 0/2 RESEND] 
Date: Thu,  2 Sep 2010 14:59:43 +0100
Message-Id: <1283435985-21934-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a resubmit of several patches I sent out earlier that adds
trace points to the mmap family.  These events report addresses and sizes when
each function returns success.  They will be used by a userspace tool that will
model memory usage.

Changes from V1:
- Group mmap, munmap, and brk into first patch (all in mmap.c) and mremap into
  second (in mremap.c)
- Use DEFINE_EVENT_CLASS and DEFINE_EVENT for mmap and brk events


Eric B Munson (2):
  Add trace points to mmap, munmap, and brk
  Add mremap trace point

 include/trace/events/mm.h |   97 +++++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                 |   15 ++++++-
 mm/mremap.c               |    4 ++
 3 files changed, 115 insertions(+), 1 deletions(-)
 create mode 100644 include/trace/events/mm.h

