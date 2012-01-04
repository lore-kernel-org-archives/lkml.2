Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2ADTGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:06:21 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51347 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab2ADTGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:06:15 -0500
Date: Wed, 4 Jan 2012 10:54:12 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michael Hennerich <michael.hennerich@analog.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [PATCH v3.2 03/10] MAINTAINERS: Update adp gpio F: patterns
Message-ID: <20120104175412.GF15503@ponder.secretlab.ca>
References: <cover.1323401278.git.joe@perches.com>
 <752ff6829eee7b258b3fd7de0a07c9f035fcf1f4.1323401278.git.joe@perches.com>
 <4EE1C3F4.6020108@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE1C3F4.6020108@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 09:16:52AM +0100, Michael Hennerich wrote:
> On 12/09/2011 05:21 AM, Joe Perches wrote:
> >Commit c103de240439df ("gpio: reorganize drivers") renamed
> >the files, update the patterns.
> >
> >CC: Grant Likely<grant.likely@secretlab.ca>
> >CC: Michael Hennerich<michael.hennerich@analog.com>
> >
> >Signed-off-by: Joe Perches<joe@perches.com>
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>

Acked-by: Grant Likely<grant.likely@secretlab.ca>

> >---
> >  MAINTAINERS |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/MAINTAINERS b/MAINTAINERS
> >index 80167e7..bfa54c1 100644
> >--- a/MAINTAINERS
> >+++ b/MAINTAINERS
> >@@ -347,7 +347,7 @@ S:	Supported
> >  F:	drivers/mfd/adp5520.c
> >  F:	drivers/video/backlight/adp5520_bl.c
> >  F:	drivers/leds/leds-adp5520.c
> >-F:	drivers/gpio/adp5520-gpio.c
> >+F:	drivers/gpio/gpio-adp5520.c
> >  F:	drivers/input/keyboard/adp5520-keys.c
> >
> >  ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
> >@@ -356,7 +356,7 @@ L:	device-drivers-devel@blackfin.uclinux.org
> >  W:	http://wiki.analog.com/ADP5588
> >  S:	Supported
> >  F:	drivers/input/keyboard/adp5588-keys.c
> >-F:	drivers/gpio/adp5588-gpio.c
> >+F:	drivers/gpio/gpio-adp5588.c
> >
> >  ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
> >  M:	Michael Hennerich<michael.hennerich@analog.com>
> 
> 
> -- 
> Greetings,
> Michael
> 
> --
> Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
> Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
> Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
> Margaret Seif
> 
> 
