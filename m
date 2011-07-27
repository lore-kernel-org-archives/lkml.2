Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1G0Ama (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:42:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1G0Aez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30470974"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: andi@firstfloor.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [3/98] Add Andi Kleen as 2.6.35 longterm maintainer
Message-Id: <20110727003455.0A9222403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:34:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <andi@firstfloor.org>

People complained about me not being in the MAINTAINERS file.
So fix that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/MAINTAINERS
===================================================================
--- linux-2.6.35.y.orig/MAINTAINERS
+++ linux-2.6.35.y/MAINTAINERS
@@ -3444,6 +3444,12 @@ F:	drivers/lguest/
 F:	include/linux/lguest*.h
 F:	arch/x86/include/asm/lguest*.h
 
+LINUX 2.6.35 LONGTERM:
+M:	Andi Kleen <andi@firstfloor.org>
+L:	stable@kernel.org
+S:	Maintained
+F:	*
+
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
 W:	http://www.ibm.com/linux/ltc/projects/ppc
