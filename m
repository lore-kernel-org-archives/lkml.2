Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1LLREO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:04:14 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:43805 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1LLREK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:04:10 -0500
Subject: [PATCH] Staging: VME: PIO2: Add GPIOLIB dependancy
To: rdunlap@xenotime.net, gregkh@suse.de
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Dec 2011 17:04:06 +0000
Message-ID: <20111212170301.26724.40502.stgit@ES-BJ21R4J>
In-Reply-To: <4EE638EA.6010909@xenotime.net>
References: <4EE638EA.6010909@xenotime.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PIO2 driver errors when GPIOLIB, on which it depends, is not enabled.

Add dependancy when selecting the PIO2.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

Sorry, missed the email on the 6th.

 drivers/staging/vme/devices/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/staging/vme/devices/Kconfig b/drivers/staging/vme/devices/Kconfig
index 8f5d286..55ec30c 100644
--- a/drivers/staging/vme/devices/Kconfig
+++ b/drivers/staging/vme/devices/Kconfig
@@ -9,6 +9,7 @@ config VME_USER
 
 config VME_PIO2
 	tristate "GE PIO2 VME"
+	depends on GPIOLIB
 	help
 	  Say Y here to include support for the GE PIO2. The PIO2 is a 6U VME
 	  slave card, implementing 32 solid-state relay switched IO lines, in


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
