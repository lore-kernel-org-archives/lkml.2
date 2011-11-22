Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1KVJH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:07:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49205 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1KVJHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:07:25 -0500
Date: Tue, 22 Nov 2011 10:07:18 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: drop 'ARCH_MX31' and 'ARCH_MX35'
Message-ID: <20111122090718.GD27267@pengutronix.de>
References: <1321882445.32195.3.camel@x61.thuisdomein>
 <20111121133603.GR9581@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121133603.GR9581@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:05:20 up 9 days, 16:52, 29 users,  load average: 1.00, 1.06, 1.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 01:36:03PM +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 21, 2011 at 02:34:05PM +0100, Paul Bolle wrote:
> > Commit 27ad4bf72a ("ARM: imx: move mx3 support to mach-imx") kept
> > ARCH_MX31 and ARCH_MX35 'for compatibility'. Now that they aren't
> > actually used anymore, they can be dropped entirely.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Sascha should be handing this patch.
> 
> ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
> M:      Sascha Hauer <kernel@pengutronix.de>
> L:      linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> S:      Maintained
> T:      git git://git.pengutronix.de/git/imx/linux-2.6.git
> F:      arch/arm/mach-mx*/
> F:      arch/arm/plat-mxc/
> 
> It may be an idea if MAINTAINERS gets updated too, so these patches find
> their way to the right person...


Indeed, I never realized that it's missing arch/arm/mach-imx

8<----------------------------------------

MAINTAINERS: Add missing directory

arch/arm/mach-imx/ is part of the i.MX support. Add it.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 071a996..c9ae02a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -789,6 +789,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.pengutronix.de/git/imx/linux-2.6.git
 F:	arch/arm/mach-mx*/
+F:	arch/arm/mach-imx/
 F:	arch/arm/plat-mxc/
 
 ARM/FREESCALE IMX51
-- 
1.7.7.1

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
