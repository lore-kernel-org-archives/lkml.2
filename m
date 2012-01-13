Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2AMAmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:42:39 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51707 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756472Ab2AMAmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:42:37 -0500
X-Sasl-enc: rEMD0b/AsOqrJKD6koH+5OCV2Yx6+nh1GFVCsYdnHPQ0 1326415356
Date: Thu, 12 Jan 2012 16:39:29 -0800
From: Greg KH <greg@kroah.com>
To: Greg White <pcguy11@live.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: MULTIPLE WARNING: at =?utf-8?Q?fs=2Fsy?=
 =?utf-8?B?c2ZzL2Rpci5jOjQ1NSBzeXNmc19hZGRfb25l4oCP4oCP?=
Message-ID: <20120113003929.GB16942@kroah.com>
References: <SNT123-W206618A1B501B8A491DFADDB9F0@phx.gbl>
 <20120112213702.GA17405@kroah.com>
 <SNT123-W46318F430CE810154029D5DB9F0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SNT123-W46318F430CE810154029D5DB9F0@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 05:51:10PM -0600, Greg White wrote:
> 
> > On Thu, Jan 12, 2012 at 02:40:18PM -0600, Greg W wrote:
> > >
> > > Hi,
> > >
> > > I just installed Linux on my HP 6200 PC using UEFI. The Ubuntu lucid kernel caused my computer to freeze during shutdown and reboots. So I downloaded 3.1.6 from kernel.org and compiled my own kernel and it works fine except for the following messages in my dmesg:
> > >
> > > [2.295957] ------------[ cut here ]------------
> > > [2.295962] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
> > > [2.295964] Hardware name: HP Compaq 6200 Pro Small Form Factor
> > > [2.295966] sysfs: cannot create duplicate filename '/firmware/efi/vars/SlotPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
> >
> > This is a BIOS problem, with EFI, go complain to your manufacturer that
> > they are creating multiple slots with the same name.
> >
> > > [2.296043] kobject_add_internal failed for
> > > SlotPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9 with -EEXIST, don't try to register things with the same name in the same directory.
> >
> > See, the kernel told you this :)
> >
> > best of luck,
> >
> > greg k-h
> 
> Thank you for the clarification.  When I see WARNING: at
> fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0() I think kernel problem. 
> If I saw WARNING: BIOS is trying to register things with the same name
> in the same directory, I would have thought BIOS issue.  Maybe you
> could make the warning a little more clear the problem is in the BIOS
> and not the kernel?

Patches are always welcome :)

thanks,

greg k-h
