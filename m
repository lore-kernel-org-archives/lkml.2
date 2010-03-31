Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab0CaCVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:21:52 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:23864 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab0CaCVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:21:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 25/33] x86, lmb: turn off ARCH_LMB_FIND_AREA
Date: Tue, 30 Mar 2010 19:17:10 -0700
Message-Id: <1270001838-15857-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BB2B121.00B7,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32bit now can use generic __find_lmb_area now. So we can turn arch one off

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1aa53ae..ce097ab 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -584,7 +584,7 @@ config PARAVIRT_DEBUG
 	  a paravirt_op is missing when it is called.
 
 config ARCH_LMB_FIND_AREA
-	default y
+	default n
 	bool "Use x86 own lmb_find_area()"
 	---help---
 	  Use lmb_find_area() version instead of generic version, it get free
-- 
1.6.4.2

