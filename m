Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0DTARF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 20:17:05 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37477 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0DTARB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 20:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T7bTjiWJVr2Nsrsy+HmsNOKglt6ReX9G+aazn3OUwVodIaBMF8oVkiih3XpKF/B3nq
         rzzUBIz1zabzb1QEfFwBq2R4PCEe0QUgwafVMDKspne+Exx1O9ch/QQxt9D6WK7lfpFx
         VPBsbGHidrrkeFBGCIlcL8gxgYrIBs71xQFhE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004151114490.1562-100000@iolanthe.rowland.org>
References: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com>
	 <Pine.LNX.4.44L0.1004151114490.1562-100000@iolanthe.rowland.org>
Date: Tue, 20 Apr 2010 01:16:58 +0100
Message-ID: <t2r74fd948d1004191716l49dedc2p25a27da39bcc614a@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>, Daniel Mack <daniel@caiaq.de>
Cc: Chris Wright <chrisw@sous-sol.org>, David Woodhouse <dwmw2@infradead.org>,
       USB list <linux-usb@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2010 16:20, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 15 Apr 2010, Pedro Ribeiro wrote:
>
>> I enabled  CONFIG_DMAR_BROKEN_GFX_WA=y and the result is the same. A
>> delay in the boot process and usb devices don't work properly,
>> including my USB mouse.
>>
>> Strange, since you have the same platform as me. The extra usb devices
>> you were seeing are because of my docking station - but it makes no
>> difference whether I'm docked or not for the purposes of the original
>> bug or this situation right now. The dmesg I'm attaching is without
>> the computer being docked.
>
> It's not possible to determine the reason for the timeout errors
> between timestamps 16 and 53 from the small amount of debugging
> information in the log.  Clearly something is going wrong with the
> communication between the computer and the EHCI controller.  And
> clearly the kernel config changes are responsible.
>
> But I don't know what to do to track it down any farther.
>
> Alan Stern
>
>

I guess this is pretty much a dead end until anyone else can reproduce it!

I'll continue to use Daniel's patches privately.

Daniel, should I use the big initial patch or the GFP_DMA one? Which
one is better for a system which is only rebooted every week or so (I
usually hibernate)?

Regards,
Pedro
