Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0GLVLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:11:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41783 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0GLVLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:11:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3B8503.2050209@s5r6.in-berlin.de>
Date: Mon, 12 Jul 2010 23:11:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Marcin Letyns <mletyns@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de>	<20100711131640.GA3503@thunk.org>	<4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com> <4C3B3B39.2000809@davidnewall.com> <4C3B585A.6090106@s5r6.in-berlin.de> <4C3B73D7.8050802@davidnewall.com>
In-Reply-To: <4C3B73D7.8050802@davidnewall.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Stefan Richter wrote:
>> If it doesn't for you, then I hope you are already in contact with the
>> respective subsystem developers to get the regressions that you
>> experience fixed.
>>   
> (Segue to a problem which follows from calling bleeding-edge kernels
> "stable".)
> 
> When reporting bugs, the first response is often, "we're not interested
> in such an old kernel; try it with the latest."

Because there are continuously going bug fixes into the new kernels.

> That's not hugely useful when the latest kernels are not suitable for
> production use.

"I have this bug here." - "It might be fixed in 2.6.mn.  Try it." - "I
don't want to because I got burned by 2.6.jk."  Well, then don't do it
and keep using the old buggy kernel.  Or use a forked kernel where
somebody adds bugfix backports and feature backports as you require
them, if that somebody does a really good job.

> If kernels weren't marked stable until they had earned the moniker,
> for example 2.6.27, then the expectation of developers and of users
> would be consistent:

2.6.27.y is what you call stable exactly because none of the boatloads
of bug fixes and improvements of each subsequent 2.6.x release goes into
it anymore.

That's the nature of the beast.  You can't have the cake and eat it.
Which is why it is important that we keep the regression count in new
kernels low and try to detect and fix regressions as early as possible.
I admit that I do not really help with this myself outside the subsystem
which I maintain.  I usually start to run -rc kernel at later -rc's only
(say, -rc5, only sometimes earlier) and don't test them beyond the one
or to two configurations that I use personally.  There were occasionally
regressions in the subsystem that I maintain but they were few and
always fixed quickly, and each one was a lesson how to do better.  So,
for that subsystem, the "Latest Stable Kernel" that is advertised on the
front page of kernel.org really and truly /is/ the latest stable release
that is recommended for production use, as far as that subsystem is
concerned.
-- 
Stefan Richter
-=====-==-=- -=== -==--
http://arcgraph.de/sr/
