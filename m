Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0GRO3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:29:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45909 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0GRO32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JIXkJQ7xdCrJvUNFqaHB9oUeQsIFNGkSsapIpy7fGxyob1OQCHl2hagamuwb1dc+oi
         kIcdtBEhz5Lc5D4RoYpsapilxB17Lkhy/vGbJQjNOOvzKUIWg7xzF/a08D0ZR5ey6fKd
         WFkHTRp0z7cr8xh7w5qrQ8WO0F7a11lzMFPzg=
Message-ID: <4C430FBC.6010603@gmail.com>
Date: Sun, 18 Jul 2010 22:29:16 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM/nuc900: add nuc900 kpi platform device structure to nuc910_dev
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add nuc900 kpi platform device structure to nuc910_dev[],
which enables nuc910 keypad support.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/nuc910.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-w90x900/nuc910.c b/arch/arm/mach-w90x900/nuc910.c
index cd49776..1523f41 100644
--- a/arch/arm/mach-w90x900/nuc910.c
+++ b/arch/arm/mach-w90x900/nuc910.c
@@ -27,6 +27,7 @@ static struct platform_device *nuc910_dev[] __initdata = {
 	&nuc900_device_ts,
 	&nuc900_device_rtc,
 	&nuc900_device_lcd,
+	&nuc900_device_kpi,
 };

 /* define specific CPU platform io map */
-- 
1.6.3.3

