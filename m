Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab1GUFEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 01:04:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60987 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1GUFEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 01:04:43 -0400
X-Auth-Info: l3u34MoUNhkiMh8LMGeU66SkakWC4bsacwrFVNfxEsU=
From: Anatolij Gustschin <agust@denx.de>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] MAINTAINERS: change maintainership of mpc5xxx
Date: Thu, 21 Jul 2011 07:04:25 +0200
Message-Id: <1311224665-19159-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant intends to hand over maintainership of mpc5xxx
to me. Change MPC5XXX entry in MAINTAINERS accordingly.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187282d..323208d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3878,9 +3878,9 @@ F:	arch/powerpc/platforms/powermac/
 F:	drivers/macintosh/
 
 LINUX FOR POWERPC EMBEDDED MPC5XXX
-M:	Grant Likely <grant.likely@secretlab.ca>
+M:	Anatolij Gustschin <agust@denx.de>
 L:	linuxppc-dev@lists.ozlabs.org
-T:	git git://git.secretlab.ca/git/linux-2.6.git
+T:	git git://git.denx.de/linux-2.6-agust.git
 S:	Maintained
 F:	arch/powerpc/platforms/512x/
 F:	arch/powerpc/platforms/52xx/
-- 
1.7.1

