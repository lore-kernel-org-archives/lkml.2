Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0KXSZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:25:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:49488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0KXSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:25:17 -0500
Date: Wed, 24 Nov 2010 10:23:53 -0800
From: Greg KH <gregkh@suse.de>
To: Scott Wood <scottwood@freescale.com>
Cc: michael@ellerman.id.au, Timur Tabi <timur@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        devicetree-discuss@vger.kernel.org
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101124182353.GA10589@suse.de>
References: <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com> <20101118112146.3275eb08@udp111988uds.am.freescale.net> <4CE5657D.8060105@freescale.com> <20101118121356.3491da72@udp111988uds.am.freescale.net> <1290594227.4446.12.camel@concordia> <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 12:08:18PM -0600, Scott Wood wrote:
> On Wed, 24 Nov 2010 21:23:47 +1100
> Michael Ellerman <michael@ellerman.id.au> wrote:
> 
> > On Thu, 2010-11-18 at 12:13 -0600, Scott Wood wrote:
> > > Unfortunately, it's not an exact match, and the fact that reg doesn't
> > > translate to a physical address means that AFAICT you'll currently get
> > > something like "byte-channel.nnn", where "nnn" is an arbitrary
> > > kernel-assigned number.
> > 
> > Can you not use device_rename() ?
> 
> Ah, didn't know about that.  Still, might be nice to add support for
> "handle" nodes at the infrastructure level rather than in each driver.

No, please never use that function, bad things will happen.

thanks,

greg k-h
