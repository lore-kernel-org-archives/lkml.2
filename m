Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0GNMj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:39:58 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43543 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017Ab0GNMjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:39:54 -0400
Date: Wed, 14 Jul 2010 14:39:52 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 02/11] Removing dead {AR,WAVE}LAN
Message-ID: <3da4fcf94d2364af32c44a8442b756c8b525f6fc.1279110894.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279110894.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{AR,WAVE}LAN doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/net/Space.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/Space.c b/drivers/net/Space.c
index 3b79c6c..9bb405b 100644
--- a/drivers/net/Space.c
+++ b/drivers/net/Space.c
@@ -218,12 +218,6 @@ static struct devprobe2 isa_probes[] __initdata = {
 #ifdef CONFIG_EL1		/* 3c501 */
 	{el1_probe, 0},
 #endif
-#ifdef CONFIG_WAVELAN		/* WaveLAN */
-	{wavelan_probe, 0},
-#endif
-#ifdef CONFIG_ARLAN		/* Aironet */
-	{arlan_probe, 0},
-#endif
 #ifdef CONFIG_EL16		/* 3c507 */
 	{el16_probe, 0},
 #endif
-- 
1.7.0.4

