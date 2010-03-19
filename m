Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab0CSJps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 05:45:48 -0400
Received: from lucidpixels.com ([75.144.35.66]:60090 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab0CSJpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 05:45:47 -0400
Date: Fri, 19 Mar 2010 05:45:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, chris.mesterharm@gmail.com
Subject: Re: 2.6.34-rc1: pci 0000:00:00.0: address space collision / spontaenous
 reboots [now 2.6.34-rc1]
In-Reply-To: <201003181719.55238.bjorn.helgaas@hp.com>
Message-ID: <alpine.DEB.2.00.1003190543140.31166@p34.internal.lan>
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan> <201003181658.38462.bjorn.helgaas@hp.com> <alpine.DEB.2.00.1003181858590.27400@p34.internal.lan> <201003181719.55238.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Mar 2010, Bjorn Helgaas wrote:

> On Thursday 18 March 2010 05:00:02 pm Justin Piszcz wrote:
>> On Thu, 18 Mar 2010, Bjorn Helgaas wrote:
>>
>>> On Saturday 13 March 2010 02:01:32 am Justin Piszcz wrote:
>>>> It stayed up for approximately 8-9 hours, then it crashed again.
>>>>
>>>> It is either a DOA motherboard OR the memory mapping is causing problems..
>>>
>>> Did you ever make any more progress on this?  I don't have any ideas;
>>> just wondering whether you learned anything.
>
>> I swapped the motherboard with the ASUS and all problems have disappeared.
>> Someone else e-mailed me with a similar issue (freeze/hang/etc) with a
>> similar motherboard (but UDP3 instead of 5 I believe) and they could not
>> find a solution either, they were trying to install Fedora.
>
> Huh.  You started with a Gigabyte board, IIRC, and replaced it with
> an ASUS, so we can't tell if you just had a defective Gigabyte board,
> or if there's something we need to fix in Linux.
>
> The other poster with a similar board and similar symptoms sounds
> interesting, though.  You don't have a pointer to a bugzilla or
> email discussion, do you?
>
> Bjorn
>
Hi,

I have cc'd him on this thread.

His board = GA-770TA-UD3
  My board = GA-MA790FXT-UD5P

The discussion:

On Wed, 17 Mar 2010, Chris Mesterharm wrote:

> Hello,
>
> Did you ever fix that Gigabyte board with the address space collision?  I'm
> have a similar problem with a GA-770TA-UD3 board using Fedora 12.  (It kept
> hanging on install, and after install it randomly locks up after a few
> hours.)  Currently I'm rerunning hardware tests.  If it passes, I'm going to
> try an older kernel and then Ubuntu.  If it fails that I'm going to send the
> board back to Newegg.
>
> Thanks,
> Chris


Hi,

Got rid of that board, I spent ~7-14 days on it, doing everything
imaginable, I have been using linux since ~1996 on my own hardware, ran
out of ideas, got a new ASUS board, no more problems.

Intel Gigabyte boards seem to be OK.
AMD ones, of this type, not so sure.

Please let me know when you end up finding!

You should run:

1. memtest first (make sure it passes, grab the system rescue cd)
2. run stress on it, etc

Justin.


