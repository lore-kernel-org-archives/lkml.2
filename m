Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab2HXSSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:18:30 -0400
Received: from mail.wdtv.com ([66.118.69.84]:43993 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab2HXSS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:18:26 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2012 14:18:26 EDT
From: Gene Heskett <gheskett@wdtv.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
Date: Fri, 24 Aug 2012 14:11:42 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.32-122-rtai; KDE/4.4.5; i686; ; )
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208241854.45656.tweek@tweek.dk> <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
In-Reply-To: <CAJ7jCmkiPrr3-pf2yspNiHHzhZBCsuWZaTRCjmi_wSdBGhB6Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201208241411.42184.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012, wbrana wrote:
>On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
>> What I'd hate even more is rendering my old working hardware useless by
>> removing x86-32 support from the kernel. To reason the removal by
>> saying "Microsoft plans to do it" just makes me go bonkers...
>
>Your old hardware will work fine with long term kernel.

Says you.

>> These legacy apps will most likely be compiled for x86-32 and not x32
>> (an argument for not removing x86-32 support on a running x86-64
>> kernel).
>
>Which legacy apps do you mean?

Any of them that have been in use, on 32 bit systems since the late 90's.  
Among us 'old hands' the rate of 64 bit installs on 64 bit hardware is 
minuscule at best, and here is one of them, running a 32 bit smp/pae 
enabled install on amd phenom 4 core 64 bit hardware.  Why?  Because the 
applications we run and have run for a decade or more simply have not ever 
been rebuilt to run on 64 bit systems.  They have no official maintainers 
to do so because they were written well in the first place and continue to 
do well on the 64 bit systems the makers have foisted off on us purely as a 
speed requirement.

I have had 2 different 64 bit installs on this box in the last 4 years,  
they were just barely noticeable as faster but they lasted less than a 
month when I realized that the programs I had been using for a decade 
simply were not available from the 64 bit only repo's and no one was 
interested in building such old but still 100% useful stuff.

So quite trying to find a problem where there is none, and go apply 
yourself to solving the lack of a full menu of the legacy apps built for 64 
bit OS's and machines.  Come back in a decade once you have solved that 
problem and suggest this insanity again.  That is approximately the right 
word for this proposal today, insane.

Alan Cox probably said it better, but at my age, likely 3, maybe 4x yours, 
I'll row in the same boat with Alan.  Put your efforts someplace useful. 
This, at this time, is not useful.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
Results vary by individual.
