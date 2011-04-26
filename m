Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab1DZVRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:17:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:58913 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab1DZVPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483935"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [106/106] Release 2.6.35.13
Message-Id: <20110426211429.2FE2B3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <andi@firstfloor.org>

Release 2.6.35.13
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/Makefile
===================================================================
--- linux-2.6.35.y.orig/Makefile
+++ linux-2.6.35.y/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = .12
+EXTRAVERSION = .13
 NAME = Yokohama
 
 # *DOCUMENTATION*
