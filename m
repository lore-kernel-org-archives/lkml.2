Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1GCN60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:58:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61248 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1GCN6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:58:25 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/7] fault-injection cleanup
Date: Sun,  3 Jul 2011 22:59:41 +0900
Message-Id: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This collection of cleanup patches removes about 100 lines of code
without reducing any functionalities of fault-injection.

Akinobu Mita (7):
  fault-injection: do not include unneeded header
  fault-injection: remove nonexistent function extern
  fault-injection: cleanup simple attribute of stacktrace_depth
  fault-injection: use debugfs_remove_recursive
  failslab: simplify debugfs initialization
  fail_page_alloc: simplify debugfs initialization
  fail_make_request: cleanup should_fail_request

 block/blk-core.c             |   26 ++++----
 include/linux/fault-inject.h |   19 +-----
 lib/fault-inject.c           |  144 ++++++++++++------------------------------
 mm/failslab.c                |   31 +++------
 mm/page_alloc.c              |   51 +++++----------
 5 files changed, 82 insertions(+), 189 deletions(-)

-- 
1.7.4.4

