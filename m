Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0IDWuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 18:50:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52277 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0IDWuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 18:50:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C82CD1B.7000607@s5r6.in-berlin.de>
Date: Sun, 05 Sep 2010 00:50:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de> <201009041839.09261.Martin@lichtvoll.de> <4C829CFF.8080905@s5r6.in-berlin.de> (sfid-20100904_213939_880548_666DFBB9) <201009042221.43862.Martin@lichtvoll.de>
In-Reply-To: <201009042221.43862.Martin@lichtvoll.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Am Samstag 04 September 2010 schrieb Stefan Richter:
>> Put simply, the paid developers work on what they are paid for.  The
>> volunteers work on what they are interested in.
> 
> And they are paid for features instead of fixing bugs?

There are lots of people who fix bugs on paid time or are even specifically
paid to fix bugs.

[...]
> I will think a bit more about this. But my first impression is that all of 
> these provisions are currently in conflict with time for feature work. If 
> there is no stabilization or sorta of freeze period, the speed won't calm 
> down in order to give stabilizitation a realistic chance.

Linus' merge--rc--release cycle only influences what is pulled into the
mainline when.  It does not prevent anyone to implement a new feature or to
stabilize an existing feature any time.

[...]
>> However, you can hardly tell people to implement less features and fix
>> more bugs if they don't owe you anything.
> 
> Sorry for the demanding tone in my post that initiated the thread, but in 
> the post you are answering too I merely made a suggestion. No one does owe 
> me anything and I am aware of that.
> 
> But still even when I do not prepend each of my mails with a list of what 
> I have done for the kernel - which is clearly less than what any core 
> kernel developer or even a casual kernel developer did for the kernel  - I 
> still can make a valuable suggestion.
> 
> That said I compiled a kernel a day or two for some time to help Ingo 
> Molnar with testing an use case for his CFS scheduler. And am I regularily 
> testing new TuxOnIce kernels and report back to Nigel how they fare. I 
> report bugs for other open source projects like KDE or Debian as well and 
> contribute a bit here and then, like my first debian package "fio".
> 
> And this work mostly has been enjoyable. Neither Ingo, nor Nigel, nor Jens 
> Axboe asked me what I did for the kernel prior to working with me. They 
> have just been happy for the feedback I gave.
> 
> I admit my initial post did well to provoke the kind of "what did you do?" 
> feedback as it actually was demanding.

By the sentence above I merely meant to say that you or I or anybody cannot
lay out work schedules for others who are not our employees. :-)

> But then I really was frustrated 
> with the kernel and I think sometimes an oppinionated post like my 
> "stable? quality assurance?" can be quite good. If I think a kernel is 
> crap, why should it be prohibited that I tell it to their developers?

It is not prohibited.  OTOH I don't know how useful it is at this general
level.  There are lots of subsystem projects in the kernel project, all in
different situations regarding how mature their subsystem is, how many
developers and testers they have, what their balance of new features vs.
stabilization work is.
-- 
Stefan Richter
-=====-==-=- =--= --=--
http://arcgraph.de/sr/
