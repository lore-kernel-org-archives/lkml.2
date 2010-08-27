Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0H0UvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:51:19 -0400
Received: from 1wt.eu ([62.212.114.60]:42556 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0H0UvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:51:18 -0400
Date: Fri, 27 Aug 2010 22:51:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: Re: Og dreams of kernels
Message-ID: <20100827205112.GA16004@1wt.eu>
References: <20100826235552.GA13527@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826235552.GA13527@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ removing Linus and Andrew not to pollute their mailboxes ]

Hi Og,

On Thu, Aug 26, 2010 at 04:55:52PM -0700, Greg KH wrote:
> {pound} {pound} {pound}
> 
> Og woke up to the loud noise of the villagers pounding on his cave door.
> He stumbled toward it, grabbing the four numbered bags that he knew were
> needed at this time.
> 
> Opening the door, Og looked at the villagers, all expectant, wondering
> where this week's kernels were, what was delaying them, as they needed
> their weekly fix.

My villagers are nicer, only two have kindly asked if they would get their
bi-yearly lunch this week. I'll have to recall the recipe and prepare the
soup.

> Reaching into the first bag, quite worn out with a faded "27" on the
> outside of it, he grabbed one of the remaining kernels in there and
> tossed it into the group.  A few small people at the back of the crowd
> caught the kernel, and slowly walked off toward the village.  Og
> wondered about these people, constantly relying on the old kernels to
> save them for another day, while resisting the change to move on,
> harboring some kind of strange reverence for this specific brand that Og
> just could not understand.

I certainly understand as I am one of them. The reason is precisely the one
that made you start this silly project : everyone has different expectations
on reliability. You don't put the same kernel on your desktop, on a SOHO
server, on an enterprise server, on an appliance or on a device you probably
won't be able to upgrade. And that's not only the kernel, it's true for all
software. The fact is that many issues fixed in recent kernels are specific
to those recent kernels. And we clearly observe that with the 2.6-stable
branches where the number of patches diminishes with time (I'm not comparing
branches between each other). I observe that even more with 2.4. Almost all
of the sensible fixes of the last 6 months did not apply to it (I just have
a few improbable ones in queue, though they're not easy to backport nor to
test).

Some of these many fixes in latest kernels may concern unreliable features
that were not present in earlier versions, some may simply be regressions.
When one kernel fits 100% of your needs, you don't want to take risks by
upgrading it if you know it is still supported, so you just apply fixes
from time to time. "If it ain't broke, don't fix it" !

And that works very well. I'm running 2.6.27.x on my desktop (2 months of
uptime, it's not up to date, but OK for what I do with it). Running 2.6.32.x
on my netbook because it needed updated drivers. I'm not tempted to update
it further simply because I use it to visit customers and I would not like
to waste time discovering that feature X or Y does not work anymore when I
need it (eventhough the risks are very low). I'm just applying the principle
above. So 2.6.32.x is perfect for it.

On an ARM-based development board, I have 2.6.35-rc2 which showed a nice
speed up and which was enough to boot and test my builds. No need for any
update there either, although I'll probably upgrade to avoid the usual
merge window bugs.

And on the load balancer appliances we're distributing at work, we're still
shipping with 2.4.37, because customers expect a high reliability with low
maintenance costs and don't want to reboot twice a year nor apply any
update which just covers bugs they have not encountered (typically security
issues). This point is important because you know that customers won't
update, and you want to ensure that even if they skip 2-3 updates, the
risk will remain very low, otherwise you have to pressure them to upgrade,
which you can't do every 6 months. For this reason, we're thinking about
upgrading to 2.6.27.x because it seems to be ready to take this role.
And by this time all my machines will be at least at 2.6.32.x ;-)

> Og looked proudly at the remaining villagers in front of him.  These
> were the strongest women, the most beautiful men, and the smartest
> children around.  They had changed over the past few years, becoming
> brighter, and more adept and the changes the world was throwing at them.
> They were self-reliant, taking whatever Og offered them, providing good
> feedback, smart bug reports, and tasty treats of plum pudding during
> the holliday season.

Unfortunately, they're not *all* like this. There's a last group, those
who try the mixture, see it fail for their usage, declare it as definitely
broken and switch back to previous versions. I know quite a bunch of them
unfortunately. When they tell me "2.6.35 is broken, I switched back to
2.6.33", I tell them that they must report the bug and try again with next
stable version. But they decline. They consider they wasted their time or
damaged the production and don't want to test that branch anymore. In my
experience, most users don't understand how the versionning works, so as
long as they see the same numbers on the left, they have no real hope for
fixes. Maybe their mind has been distorted by other products :-/
(yes this is stupid, but the fix for "users" has not been merged yet).

> Og reached into his bag marked with a big "35" and tossed a plump, jucy
> kernel at this final group, who instantly grabbed it up, thanked him for
> providing it (unlike those self-absorbed 32 and 27 people) and ran off
> to help spread the good news of a new kernel.

I too know what you mean here, but I see this as a positive lack of
feedback (it's a thankless work after all). It means that the ones who
never thank you just expect it to work, see it work and find it normal.
It's just a proof that you've excelled at your task !

Cheers,
Willy

[PS: and thanks for these updates to the 3 kernels I use]

