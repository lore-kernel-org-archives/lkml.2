Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1HXDPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:15:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37772 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1HXDPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:15:10 -0400
Date: Wed, 24 Aug 2011 11:14:59 +0800
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilya Gorskin <Revent82@gmail.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Staging: cx25821: fix coding style issues
Message-ID: <20110824111459.7320e557@inspire>
In-Reply-To: <20110823214421.GF3679@kroah.com>
References: <1312275798-9669-1-git-send-email-leonidsbox@gmail.com>
	<20110823214421.GF3679@kroah.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 14:44:21 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Aug 02, 2011 at 05:03:18PM +0800, Leonid V. Fedorenchik wrote:
> > Fix too long lines in cx25821-audio.h
> > Fix wrong brace placement in cx25821-cards.c, cx25821-core.c,
> > and cx25821-i2c.c
> > Use DEFINE_PCI_DEVICE_TABLE for cx25821_pci_tbl.
> > Move EXPORT_SYMBOL(cx25821_set_gpiopin_direction) to the right place.
> > Delete file cx25821-gpio.h since it is not used.
> > Get rid of typedef in cx25821.h.
> 
> I prefer to get patches in a "one patch per thing you did" format.
> 
> So, care to split this up into a number of smaller patches, all doing
> the individual thing you list above?
> 
> Yes, it's going to be a bunch of small patches, but then they will be
> "obviously" correct and trivial to review and apply.
> 
> thanks,
> 
> greg k-h

OK, no problem. I'll do this.

Leonid V. Fedorenchik
