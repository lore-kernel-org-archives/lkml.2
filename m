Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2KKWij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 17:38:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56229 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2KKWii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 17:38:38 -0500
MIME-Version: 1.0
Date: Mon, 12 Nov 2012 00:38:37 +0200
X-Google-Sender-Auth: 4lODs9ncI4uvYy2MrBaDMXwrVZA
Message-ID: <CAE7jHC-Z9wy=5HPzhZZpupcBVn862ERq1LRF9KQ=Ed7BXiDFBA@mail.gmail.com>
Subject: Porting board initialization for fdt
From: Constantine Shulyupin <const@makelinux.com>
To: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        tim.bird@am.sony.com, pandaboard@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is architecture and the best strategy to port board initialization to fdt?

Let's see for example omap4_ehci_init and usbhs_bdata @
arch/arm/mach-omap2/board-omap4panda.c.

How to perform board specific initializations?
Can omap4_ehci_init be converted to probe function of new platform
driver  omap4_ehci?
Where and how define GPIO, clock?
Should it be defined in of_dev_auxdata or in fdt?

Thanks

-- 
Constantine Shulyupin
http://www.MakeLinux.com/
Embedded Linux Systems
