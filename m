Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1GaO0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 10:26:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49901 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1GaO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 10:26:33 -0400
Date: Sat, 30 Jul 2011 22:12:30 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] input: xilinx_ps2: Add missing of_address.h header
Message-ID: <20110731041230.GO24334@ponder.secretlab.ca>
References: <1310564781-5979-1-git-send-email-monstr@monstr.eu>
 <CACxGe6vRZ4tCALpzFng2y9W_9zB3qQEntma+z292FXzDuYBRKQ@mail.gmail.com>
 <4E2C2362.1080204@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2C2362.1080204@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 03:51:30PM +0200, Michal Simek wrote:
> Hi Grant,
> 
> can you propose this patch to mainline through your devicetree tree?

I've got it in a "input/next" branch.  Since the input maintainer
doesn't seem to be active on driver patches, I'll send a pull req to
Linus.

g.

> 
> Thanks,
> Michal
> 
> Grant Likely wrote:
> >On Wed, Jul 13, 2011 at 10:46 PM, Michal Simek <monstr@monstr.eu> wrote:
> >>Add missing header.
> >>
> >>Error log:
> >>CC      drivers/input/serio/xilinx_ps2.o
> >>drivers/input/serio/xilinx_ps2.c: In function 'xps2_of_probe':
> >>drivers/input/serio/xilinx_ps2.c:249: error: implicit declaration of function 'of_address_to_resource'
> >>
> >>Signed-off-by: Michal Simek <monstr@monstr.eu>
> >
> >Acked-by: Grant Likely <grant.likely@secretlab.ca>
> >
> >>---
> >> drivers/input/serio/xilinx_ps2.c |    2 +-
> >> 1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
> >>index 80baa53..d64c5a4 100644
> >>--- a/drivers/input/serio/xilinx_ps2.c
> >>+++ b/drivers/input/serio/xilinx_ps2.c
> >>@@ -23,7 +23,7 @@
> >> #include <linux/init.h>
> >> #include <linux/list.h>
> >> #include <linux/io.h>
> >>-
> >>+#include <linux/of_address.h>
> >> #include <linux/of_device.h>
> >> #include <linux/of_platform.h>
> >>
> >>--
> >>1.5.5.6
> >>
> >>
> >
> >
> >
> 
> 
> -- 
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
> Microblaze U-BOOT custodian
