Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab2DYGWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:22:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50065 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab2DYGWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:22:43 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-01-4f97983132a8
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/6] zsmalloc: clean up and fix arch dependency
Date: Wed, 25 Apr 2012 15:23:08 +0900
Message-Id: <1335334994-22138-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset has some clean up patches(1-5) and remove 
set_bit, flush_tlb for portability in [6/6].

Minchan Kim (6):
  zsmalloc: use PageFlag macro instead of [set|test]_bit
  zsmalloc: remove unnecessary alignment
  zsmalloc: rename zspage_order with zspage_pages
  zsmalloc: add/fix function comment
  zsmalloc: remove unnecessary type casting
  zsmalloc: make zsmalloc portable

 drivers/staging/zsmalloc/Kconfig         |    4 --
 drivers/staging/zsmalloc/zsmalloc-main.c |   73 +++++++++++++++++-------------
 drivers/staging/zsmalloc/zsmalloc_int.h  |    3 +-
 3 files changed, 43 insertions(+), 37 deletions(-)

-- 
1.7.9.5

