Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1DISKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 14:10:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60470 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab1DISKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 14:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ifENle/cIQFmKgqS1uWrJ9ynul98KnBUUKa8ANwe5WXH3HUBPW/9SjGs7B6vnDYPgw
         XnWltsSUkZSTlI1CyunLzAY/rqeL31u+nQuHgfzOIrM0IWtaEtV04q5J1WWols6HZPPe
         Ci87aJHf408hXpOgmh7yUmC1Ye6G+WRltMUrI=
From: wanlong.gao@gmail.com
To: benh@kernel.crashing.org, paulus@samba.org, anton@samba.org,
        grant.likely@secretlab.ca, galak@kernel.crashing.org,
        sfr@canb.auug.org.au, jwboyer@linux.vnet.ibm.com,
        david.woodhouse@intel.com, akpm@linux-foundation.org, mingo@elte.hu,
        geoff@infradead.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] powerpc:fix build warning of the defconfigs
Date: Sun, 10 Apr 2011 02:09:46 +0800
Message-Id: <1302372586-2637-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

BT_L2CAP and BT_SCO have changed to bool .
Value 'm' has invalid .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/powerpc/configs/c2k_defconfig    |    4 ++--
 arch/powerpc/configs/pmac32_defconfig |    4 ++--
 arch/powerpc/configs/ppc6xx_defconfig |    4 ++--
 arch/powerpc/configs/ps3_defconfig    |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_defconfig
index f9e6a3e..2a84fd7 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -132,8 +132,8 @@ CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
 CONFIG_NET_CLS_IND=y
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index ac4fc41..f8b394a 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -112,8 +112,8 @@ CONFIG_IRDA_CACHE_LAST_LSAP=y
 CONFIG_IRDA_FAST_RR=y
 CONFIG_IRTTY_SIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 0a10fb0..2142089 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -351,8 +351,8 @@ CONFIG_VLSI_FIR=m
 CONFIG_VIA_FIR=m
 CONFIG_MCS_FIR=m
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index caba919..6472322 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -52,8 +52,8 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_INET_DIAG is not set
 CONFIG_IPV6=y
 CONFIG_BT=m
-CONFIG_BT_L2CAP=m
-CONFIG_BT_SCO=m
+CONFIG_BT_L2CAP=y
+CONFIG_BT_SCO=y
 CONFIG_BT_RFCOMM=m
 CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
-- 
1.7.3

