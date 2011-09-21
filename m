Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1IUAdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 20:33:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48105 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1IUAdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 20:33:36 -0400
Date: Wed, 21 Sep 2011 10:33:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20110921103329.c24fb7e8c8b34217c38f92b2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-integrator/integrator_ap.c between commit b71d8429ec36
("mach-integrator: fix VGA base regression") from Linus' tree and commit
b79573586838 ("ARM: 7087/2: mach-integrator: get timer frequency from
clock") from the arm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-integrator/integrator_ap.c
index 8cdc730,c698811..0000000
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@@ -32,7 -32,7 +32,8 @@@
  #include <linux/interrupt.h>
  #include <linux/io.h>
  #include <linux/mtd/physmap.h>
+ #include <linux/clk.h>
 +#include <video/vga.h>
  
  #include <mach/hardware.h>
  #include <mach/platform.h>
