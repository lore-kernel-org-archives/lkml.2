Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1EZOvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:51:45 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59738 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab1EZOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:51:44 -0400
Date: Thu, 26 May 2011 16:48:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        trivial@kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH][Trivial] ARM: remove duplicate include from
 arch/arm/mach-dove/common.c
Message-ID: <20110526144804.GA31651@lunn.ch>
References: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1105261130190.17400@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl pointed out there is a redundant include of
linux/serial_8250.h. However it turns out both are redundant.
This patch removes them both.

Only compile tested.

Reported-by:  Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-dove/common.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 5ed51b8..83dce85 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -13,11 +13,9 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
-#include <linux/serial_8250.h>
 #include <linux/clk.h>
 #include <linux/mbus.h>
 #include <linux/ata_platform.h>
-#include <linux/serial_8250.h>
 #include <linux/gpio.h>
 #include <asm/page.h>
 #include <asm/setup.h>
-- 
1.7.4.4

