Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab1AMKFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:05:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57216 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1AMKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:05:16 -0500
Date: Thu, 13 Jan 2011 10:04:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, Dave Martin <dave.martin@linaro.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: relocation out of range (when loading a module)
Message-ID: <20110113100407.GB24149@n2100.arm.linux.org.uk>
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home> <4D2BFA08.5030104@ahsoftware.de> <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com> <20110111155930.GH11039@n2100.arm.linux.org.uk> <4D2D1942.4050905@ahsoftware.de> <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com> <alpine.LFD.2.00.1101121314470.25498@xanadu.home> <20110112184258.GH11039@n2100.arm.linux.org.uk> <4D2E928D.9030208@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2E928D.9030208@ahsoftware.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:50:05AM +0100, Alexander Holler wrote:
> Hello,
>
> Am 12.01.2011 19:42, schrieb Russell King - ARM Linux:
>
>> As the overall feeling at the time was "don't use large initrds" it's
>> something I've never really cared about - and I'm still of the opinion
>> that 16MB of compressed initrd/initramfs is rather silly.
>
> Hmm, sorry, I have to disagree. ;)
> E.g. 12MB out of the 16MB in the initramfs I've used are modules.
> I've also created some larger initramfs wich included  X11 and such, and  
> I find it very convenient to use the initramfs to include a rootfs in  
> the the kernel and so only have to handle one file for all. E.g. just  
> load the kernel with the included rootfs via tftp and you are done.

Oddly, that's why I wrote the bootp wrapper, which predates the
currently broken initrd-in-kernel idea.

> Sure this can all be done using an external initrd, but that is much  
> less comfortable to use.
>
> At least I like that feature since it is available and won't miss it now. ;)

The feature isn't available if it doesn't work.  It's not going to get
fixed for 2.6.38 - it'll be 2.6.39 due to the timing and complexity of
the problem.
