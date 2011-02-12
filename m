Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1BLReR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:34:17 -0500
Received: from void.printf.net ([89.145.121.20]:55978 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1BLReI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:34:08 -0500
Date: Sat, 12 Feb 2011 17:34:07 +0000
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: add ricoh e823 pci id
Message-ID: <20110212173407.GB9608@void.printf.net>
References: <1297463131-3557-1-git-send-email-manoj.iyer@canonical.com> <1297463131-3557-2-git-send-email-manoj.iyer@canonical.com> <20110211224234.GA1958@void.printf.net> <201102121829.26608.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102121829.26608.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 06:29:26PM +0100, Arnd Bergmann wrote:
> On Friday 11 February 2011 23:42:34 Chris Ball wrote:
> > >  
> > >       {
> > > +             .vendor         = PCI_VENDOR_ID_RICOH,
> > > +             .device         = 0xe823,
> > > +             .subvendor      = PCI_ANY_ID,
> > > +             .subdevice      = PCI_ANY_ID,
> > > +             .driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
> > > +     },
> > > +
> > > +     {
> > >               .vendor         = PCI_VENDOR_ID_ENE,
> > >               .device         = PCI_DEVICE_ID_ENE_CB712_SD,
> > >               .subvendor      = PCI_ANY_ID,
> > 
> > Thanks, pushed to mmc-next for .39.
> 
> Wouldn't this be a candidate for -stable as well?

Yes, makes sense, will add a stable tag.  Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
