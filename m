Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1A1TAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:00:53 -0500
Received: from mail132.messagelabs.com ([216.82.242.115]:32910 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab1A1TAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:00:52 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-132.messagelabs.com!1296241235!12455190!7
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] soc: neo1973_wm8753 audio support does not require scoop
Date: Fri, 28 Jan 2011 12:00:18 -0700
User-Agent: KMail/1.9.9
CC: <alsa-devel@alsa-project.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201101281200.18371.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver does not use any of the functionality provided by the scoop
hardware.  Remove the unneeded header.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index c7a2451..c5b3113 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -24,7 +24,6 @@
 #include <sound/tlv.h>
 
 #include <asm/mach-types.h>
-#include <asm/hardware/scoop.h>
 #include <mach/regs-clock.h>
 #include <mach/regs-gpio.h>
 #include <mach/hardware.h>
