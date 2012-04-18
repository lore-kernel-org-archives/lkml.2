Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2DRF7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:59:21 -0400
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:53798 "EHLO
	bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751180Ab2DRF7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:59:20 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 01:59:20 EDT
Date: Wed, 18 Apr 2012 07:51:40 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: BCM36xx support. 
Message-ID: <20120418055139.GA25952@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While working on SPI and I2C support for the BCM2835, I found the
BCM63xx SPI driver in the kernel. Turns out that this support
was partially merged: 

The support can only be enabled when BCM63xx configuration symbol
is defined which menuconfig lists as: 

 Symbol: BCM63XX [=BCM63XX]                                                
   Type  : unknown                                                           

I'd say the definition of this is not possible through the normal
channels.

And in the driver (drivers/spi/spi-bcm63xx.c) I see: 

#include <bcm63xx_dev_spi.h>

but that file is not in the current git release.

(some more googling has resulted in me finding out that I don't want
to know how the 63xx SPI controller works as it's for a MIPS processor
while the 2835 is ARM).

Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
The plan was simple, like my brother-in-law Phil. But unlike
Phil, this plan just might work.
