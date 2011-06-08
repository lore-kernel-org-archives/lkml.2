Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1FHUbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:31:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41954 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1FHUbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:31:01 -0400
Date: Wed, 8 Jun 2011 21:30:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jim Bos <jim876@xs4all.nl>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110608203037.GA31052@srcf.ucam.org>
References: <20110608192321.GA28865@srcf.ucam.org>
 <4DEFCD07.5020505@kernel.org>
 <20110608192950.GA29235@srcf.ucam.org>
 <4DEFCF1A.9030400@kernel.org>
 <20110608193833.GA29855@srcf.ucam.org>
 <4DEFD220.5040507@kernel.org>
 <20110608195250.GB30256@srcf.ucam.org>
 <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org>
 <4DEFDA4A.9080500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEFDA4A.9080500@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 01:23:38PM -0700, Yinghai Lu wrote:
> On 06/08/2011 01:09 PM, Matthew Garrett wrote:
> > On Wed, Jun 08, 2011 at 01:03:25PM -0700, Yinghai Lu wrote:
> >> On 06/08/2011 12:52 PM, Matthew Garrett wrote:
> >>> On Wed, Jun 08, 2011 at 12:48:48PM -0700, Yinghai Lu wrote:
> >>>> On 06/08/2011 12:38 PM, Matthew Garrett wrote:
> >>>>> On Wed, Jun 08, 2011 at 12:35:54PM -0700, Yinghai Lu wrote:
> >>>>>> On 06/08/2011 12:29 PM, Matthew Garrett wrote:
> >>>>>>>> what former? you can not fix some corner case by breaking most other cases.
> >>>>>>>
> >>>>>>> All Dell laptops, all new Apples, some Lenovos, various Intel server 
> >>>>>>> platforms. That I've found so far.
> >>>>>>
> >>>>>> do you mean before that patch, all those machine will not boot linux kernel with UEFI support?
> >>>>>
> >>>>> Correct.
> >>>>
> >>>> with or without EFI runtime services?
> >>>
> >>> They'll boot with noefi, but that's useless because there's then no way 
> >>> to configure a bootloader.
> >>
> >> efibootmgr will need boot services in addition to run-time services?
> > 
> > No, SetVirtualAddressMap() calls into boot services. This is code, not 
> > data. We have no control over what it does.
> 
> Maybe you can parse efimeminfo in arch/x86/boot/compressed/head_64.S to find right decompress position for kernel.

Hm. I'll take a look into that. Thanks!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
