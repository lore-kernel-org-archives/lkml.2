Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1BBApa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:26982 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab1BBAp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418512"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: andi@firstfloor.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [139/139] Subject: Release 2.6.35.11
Message-Id: <20110202004539.32E673E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andi Kleen <andi@firstfloor.org>

Release 2.6.35.11

Index: linux-2.6.35.y/Makefile
===================================================================
--- linux-2.6.35.y.orig/Makefile
+++ linux-2.6.35.y/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 35
-EXTRAVERSION = .10
+EXTRAVERSION = .11
 NAME = Yokohama
 
 # *DOCUMENTATION*
