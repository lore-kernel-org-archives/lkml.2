Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab0IVFDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:03:11 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:36459 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab0IVFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:03:09 -0400
Date: Wed, 22 Sep 2010 15:03:04 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
In-Reply-To: <4C9988D5.5010700@gmail.com>
Message-ID: <alpine.LNX.2.00.1009221502310.7689@nippy.intranet>
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1009211518290.9370@nippy.intranet> <4C9988D5.5010700@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Sep 2010, Justin P. Mattock wrote:

> 
> > diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
> > index fbdc765..8803ed9 100644
> > --- a/drivers/hwmon/adcxx.c
> > +++ b/drivers/hwmon/adcxx.c
> > @@ -14,7 +14,7 @@
> >   *   and 101 for 1 MSPS)
> >   *
> >   * Complete datasheets are available at National's website here:
> > - * http://www.national.com/ds/DC/ADC<bb><c>S<sss>.pdf
> > + * http://www.national.com/products/catalog.do
> >Wrong. Google this and you will see what I mean.
> 
> >site:www.national.com inurl:ds/DC
> 
> looking at this one, I think it might be better to leave alone,
> reading the info above the url gives better insight on how they came up with:
> ADC<bb><c>S<sss>.pdf
> 
> or I can just use: http://www.national.com/analog/documents/guides

If it ain't broke, don't fix it.

Finn

> googling does gives results, but the part number is up to the person doing the
> designing etc..(searches are showing nothing with adcxx
> just the companies product numbers for their products).
> 
> Justin P. Mattock
> 
