Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab0LaAJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:09:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37332 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0LaAJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:09:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UVIuQ4sZVcNzH8rGk6sFSXYZZQZL37OZc/vBrLHzDD1gb0dySloT2ZeUttO+YIFSkH
         nlj9rJ1Ni2vpzA70fwVQQWWcYHnDMBRNjFAH8elXkeoJH+tdrfQzG9fClrzIMahUMC5p
         G3YCvowTXbQ2fnlGE9OJY3B47KSApmYQMoR1M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/5]arch:powerpc:platforms:85xx:mpc85xx_mds.c Typo change singal to signal
Date: Thu, 30 Dec 2010 16:09:40 -0800
Message-Id: <1293754184-1928-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches below fixes a typo "singal" to "signal". Please let me 
know if anything needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/powerpc/platforms/85xx/mpc85xx_mds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index aa34cac..747d1ee 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -309,7 +309,7 @@ static void __init mpc85xx_mds_qe_init(void)
 			/* P1021 has pins muxed for QE and other functions. To
 			 * enable QE UEC mode, we need to set bit QE0 for UCC1
 			 * in Eth mode, QE0 and QE3 for UCC5 in Eth mode, QE9
-			 * and QE12 for QE MII management singals in PMUXCR
+			 * and QE12 for QE MII management signals in PMUXCR
 			 * register.
 			 */
 				setbits32(pmuxcr, MPC85xx_PMUXCR_QE0 |
-- 
1.6.5.2.180.gc5b3e

