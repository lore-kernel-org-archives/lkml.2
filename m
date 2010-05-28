Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0E1FKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:10:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60326 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab0E1FKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xcFURsvj6uhOCPLkPHbPlUHacH3BZ8uFGU2M3TMUNXNEp5GuzSRBIa+iw6yk1WNRi9
         k56cMlSbNX2VIAXrY5e9A6+RCK6Dj+KCrOnOSo9wW5HfV6pyYhpL0R99zJ6b+qPd/Nh/
         t8N1Hheq8xNLJYSW2Nth9AIP7C8i0Q6A3xzgQ=
Date: Thu, 27 May 2010 22:10:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100528051020.GC2663@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <20100513160117.GB22238@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
 <4BFE0FAB.9040009@gmail.com>
 <alpine.LFD.2.00.1005270956380.3689@i5.linux-foundation.org>
 <AANLkTimkI2rLOO2vaPFBQUbzr5t0pAQGQ5R5noTOBp4K@mail.gmail.com>
 <alpine.LFD.2.00.1005271744410.11382@i5.linux-foundation.org>
 <4B59D6F4-825C-4851-929F-DCA28A343B23@gmail.com>
 <4BFF4120.7030501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFF4120.7030501@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:05:52PM -0600, Robert Hancock wrote:
> On 05/27/2010 07:03 PM, Dmitry Torokhov wrote:
> >On May 27, 2010, at 5:46 PM, Linus Torvalds
> ><torvalds@linux-foundation.org> wrote:
> >
> >>
> >>
> >>On Thu, 27 May 2010, Robert Hancock wrote:
> >>>
> >>>It's highly unlikely that they are incomplete in this respect, as
> >>>since I mentioned, Windows would fail to recognize the PS/2 controller
> >>>that people would expect to work, which would most likely get
> >>>noticed..
> >>
> >>Did you miss the part where I actually quoted my own modern Core i5
> >>machine that _does_ have a keyboard controller, and _does_ have a
> >>keyboard
> >>port, and that does _not_ mention them in the PnP tables?
> >
> >Except that it _does_. But _our_ ACPI implementation drops all inactive
> >devices so our PNP layer does not see your mouse and keyboard ports.
> 
> That's likely true - 

This was not a guess - I have seen DSDT from Linus' box.

That is why I said I'd be happy applying Metthew's patch if our ACPI did
not drop inactive devices - it would leave Apple and newer boxes alone
while still allowing plugging in keyboard/mouse in boxes that do have
i8042 even if BIOS decided to hide it from Windows.

-- 
Dmitry
