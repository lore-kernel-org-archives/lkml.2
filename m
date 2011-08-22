Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1HVQ1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:27:22 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:62531 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1HVQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:27:18 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/4] debug-pagealloc improvements
Date: Tue, 23 Aug 2011 01:29:04 +0900
Message-Id: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series includes three improvements for the debug-pagealloc
feature for no-architecture support (!ARCH_SUPPORTS_DEBUG_PAGEALLOC) and
one introduction of the new string library function (memchr_inv).

Akinobu Mita (4):
  debug-pagealloc: use plain __ratelimit() instead of
    printk_ratelimit()
  debug-pagealloc: add support for highmem pages
  string: introduce memchr_inv
  debug-pagealloc: use memchr_inv

 fs/logfs/logfs.h       |    1 -
 fs/logfs/super.c       |   22 --------------
 include/linux/string.h |    1 +
 lib/string.c           |   54 +++++++++++++++++++++++++++++++++++
 mm/debug-pagealloc.c   |   73 +++++++++++++++++++++++------------------------
 mm/slub.c              |   47 +-----------------------------
 6 files changed, 93 insertions(+), 105 deletions(-)

-- 
1.7.4.4

