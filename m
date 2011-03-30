Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387Ab1C3VKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:26768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965364Ab1C3VKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621239679"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [275/275] Release 2.6.35.12
Message-Id: <20110330210843.2C8FD3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/Makefile
===================================================================
--- linux-2.6.35.y.orig/Makefile	2011-03-10 08:45:08.000000000 -0800
+++ linux-2.6.35.y/Makefile	2011-03-29 23:58:30.608078326 -0700
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = .11
+EXTRAVERSION = .12
 NAME = Yokohama
 
 # *DOCUMENTATION*
