Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2FJKuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:50:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2FJKuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:50:02 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3 00/10] minor frontswap cleanups and tracing support
Date: Sun, 10 Jun 2012 12:50:58 +0200
Message-Id: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of these patches are minor cleanups to the mm/frontswap.c code, the big
chunk of new code can be attributed to the new tracing support.

Changes in v3:
 - Fix merge error
 - Commenct about new spinlock assertions

Changes in v2:
 - Rebase to current version
 - Address Konrad's comments

Sasha Levin (10):
  mm: frontswap: remove casting from function calls through ops
    structure
  mm: frontswap: trivial coding convention issues
  mm: frontswap: split out __frontswap_curr_pages
  mm: frontswap: split out __frontswap_unuse_pages
  mm: frontswap: split frontswap_shrink further to simplify locking
  mm: frontswap: make all branches of if statement in put page
    consistent
  mm: frontswap: remove unnecessary check during initialization
  mm: frontswap: add tracing support
  mm: frontswap: split out function to clear a page out
  mm: frontswap: remove unneeded headers

 include/trace/events/frontswap.h |  167 ++++++++++++++++++++++++++++++++++++++
 mm/frontswap.c                   |  162 +++++++++++++++++++++++-------------
 2 files changed, 270 insertions(+), 59 deletions(-)
 create mode 100644 include/trace/events/frontswap.h

-- 
1.7.8.6

