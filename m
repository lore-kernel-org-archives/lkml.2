Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab0IZWxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:53:35 -0400
Received: from imr3.ericy.com ([198.24.6.13]:39319 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab0IZWxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:53:34 -0400
Date: Sun, 26 Sep 2010 15:52:52 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "jbeulich@novell.com" <jbeulich@novell.com>,
        "r.marek@assembler.cz" <r.marek@assembler.cz>
Subject: Re: 2.6.36-rc5+: drivers/hwmon/coretemp.c:506: error: implicit
 declaration of function 'cpu_sibling_mask'
Message-ID: <20100926225252.GA29713@ericsson.com>
References: <201009262317.50500.thomas@m3y3r.de>
 <20100926154011.61333ffd.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100926154011.61333ffd.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 06:40:11PM -0400, Randy Dunlap wrote:
> On Sun, 26 Sep 2010 23:17:50 +0200 Thomas Meyer wrote:
> 
> > $ make V=2
> >   CHK     include/linux/version.h
> >   CHK     include/generated/utsrelease.h
> >   CALL    scripts/checksyscalls.sh - due to target is PHONY
> >   CHK     include/generated/compile.h
> >   CC [M]  drivers/hwmon/coretemp.o - due to target missing
> > drivers/hwmon/coretemp.c: In function 'coretemp_device_remove':
> > drivers/hwmon/coretemp.c:506: error: implicit declaration of function 'cpu_sibling_mask'
> > make[2]: *** [drivers/hwmon/coretemp.o] Error 1
> > make[1]: *** [drivers/hwmon] Error 2
> > make: *** [drivers] Error 2
> > 
> > above function is not defined on UP.
> 
> Patch just posted:
> 
> http://lkml.org/lkml/2010/9/26/112
> 
> 
... with apologies

Guenter
