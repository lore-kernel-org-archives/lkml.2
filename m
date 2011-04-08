Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1DHReA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:34:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42558 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab1DHRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CYDyR4uBASJbr54htN9Up0B5kNc785/hPCUaYjOafUgJug2hurcAiTGLlnGaLwnt+1
         BqYShvJw8S79Bft41D5DpJ7TqL/LVTVtFuGYzHy5/ViTnNd6jL+sjB/w2C2EA69Xmci3
         iK003NwNEcV/1u5MFgZ7+Un3REhltL1cSUSB4=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Chris Zankel <chris@zankel.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Trivial patches <trivial@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] xtensa: Remove obsolete kernel option
Date: Fri,  8 Apr 2011 19:33:50 +0200
Message-Id: <1302284030-22333-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL doesn't exist anymore so remove CONFIG_LOCK_KERNEL.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 arch/xtensa/configs/s6105_defconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 42b7feb..4891abb 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -23,7 +23,6 @@ CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
-CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
-- 
1.7.4.1

