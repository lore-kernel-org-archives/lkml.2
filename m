Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2DORP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 13:15:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48576 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2DORP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 13:15:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120415065124.GC29563@gmail.com>
References: <20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
	<CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
	<CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
	<CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
	<CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
	<CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com>
	<20120414104733.GA4871@gmail.com>
	<CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com>
	<20120415065124.GC29563@gmail.com>
Date: Sun, 15 Apr 2012 20:15:23 +0300
Message-ID: <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 9:51 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Felipe Contreras <felipe.contreras@gmail.com> wrote:

>> You are avoiding the argument you replying to; yesterday a
>> patch was droppable from the stable review queue, but today,
>> after the release, now we *need* it to stay there until it's
>> fixed in the mainline. What changed?
>
> What changed: the stable kernel was released and a new cycle
> started.

This is not a reason, this is just stating what happens without
explaining *why*.

Q: What changes when a tag is made?
A: A tag is made

> If something is broken in -stable it needs to be reverted upstream. Full stop.

And now you are describing the rule, without explaining the reason.

>> What makes a patch droppable yesterday, but dependent on
>> mainline today?
>
> Time and version release engineering: once a stable kernel is
> released any temporary integration testing results are flushed -

Yeah, but *why*? *Why* flush the testing results?

> the upstream kernel is where we maintain the information of
> which patch is broken and which not.

Sure, but that has nothing to do with the difference between today and
yesterday; both patches come from upstream. In both cases upstream
needs to be fixed.

> This memory-less process, amongst other things, helps the *next*
> major stable kernel become more robust, as it removes the
> possibility for version skew between stable and upstream.

If you keep the broken patch from yesterday (which is also from
upstream) and push it into the release, wouldn't that reduce the
version skew between stable and upstream as well?

Why is it that the patch from yesterday doesn't reduce the version
skew, but the patch from today does? You are not explaining *why*.

> If you want a revert you either need to report your problem fast
> enough to be caught in -stable integration testing, or you need
> to work with upstream to push the fix through properly.

And now you are assuming your assumption is right, and go right onto
the conclusion.

> People explained this to you, again and again, you refused to
> listen, repeatedly, again and again. There does not appear to be
> any rational set of arguments that will make you admit that you
> were wrong about this.

I'm sure if I try to argue rationally why hunting is bad with hunters,
they'll say I've refused to listen to all their rational set of
arguments. It's impossible that you are not explaining the *reason*
(there is none), it's impossible that you are being affected by herd
mentality, overconfidence, and confirmation bias. No, it cannot be any
of those things.

> Anyway, in this discussion you have demonstrated it again why
> you are one of the very few commenters I had to permanently
> block on G+ ...

Please, I provided irrefutable evidence for my argument, and I said I
would stop if you wanted me to, nobody forced you to continue the
discussion. You still blocked me even though you could have asked me
not to reply.

I can stop the discussion, I told so to Linus Torvalds on G+, if I'm told so.

I guess that would make you happy, but that doesn't mean you are
right. You are tip-toeing around the question and *never* giving a
real reason for why the patch from yesterday is different from the one
today.

It's like I'm asking why the freezer area is different from the normal
refrigerator area, and you are saying; well it's colder, it's usually
smaller, and it makes all food taste better. So you are either just
describing the differences without explaining the reason (being colder
helps for some foods), or you are providing an unsubstantiated claim;
you go from a) it's colder, to b) it makes all food taste better. And
when asked *why* again, you repeat, well, because it's colder. And
then you immediately go to the conclusion; therefore you should put as
much food in the freezer as possible.

Of course you would think all your answers are obvious and reasonable,
what else would you think? You, like everybody else (including me),
has a bias blind spot.

The fact of the matter is that there's *no reason* why the patch from
yesterday can be dropped, and the patch today can't. A tag was made,
but it doesn't change the nature of the patch; either way the patch is
bad, either way the patch is still in upstream.

You assume (correctly) that by keeping it in the stable branch, it
would guarantee it will be fixed in upstream sooner, but do we *need*
this guarantee? Would you buy a total guarantee for your house, if it
costs as much as the house itself? No, you need to look at the costs,
and the likelihood of the event you are guaranteeing against
happening, not just go "Oh!, guarantee! gimme!". The fact is that
without this guarantee, the fix will happen in a reasonable time in
upstream anyway. People have explained that in the past there have
been situations where fixes are lost, but that's an entirely different
situation (..v3.3), we are talking about stable reverts
(v3.3...v3.3.1), I challenged David Miller to find evidence for this
*ever* happening, and of course I didn't receive any answer. So no,
there's no evidence for that happening, you just think it will, let
alone how often will that be. You are making these patches guilty by
association. Plus, as I argued, somehow the 10000 of patches in queue
for the next stable release don't need this guarantee, so what's so
bad about making the patch from today one more of them?

And even more, even supposing we want this guarantee for the patch
from today, that doesn't explain why we don't want it from the patch
from yesterday. Again, this difference has *never* been explained. You
keep explaining why we want the guarantee, but never explain we why
don't want/need it for the patch from yesterday.

So you say bad patch should obviously not make it into stable:
Ingo: "if a -stable commit does not even apply or does not even boot
on Greg's box or on the handful of boxes that test stable release
candidates then it obviously cannot become part of the -stable queue."

And when asking why not get the same guarantee for the bad patch from yesterday:
Stefan: "That would be even sillier than the discussion which we are having."

When pressed about why it's sillier for the yesterday patch, but not
from today, Stefan Richter didn't reply, of course.

You are backed into a corner, you can't provide a good reason why you
treat them differently, so you are either going to keep describing the
difference, or you are going to keep explaining why the guarantee is
good, but not why B needs it, and A doesn't; because you don't have a
reason.

And when backed into a corner you are going to do what everybody does,
not stop for a second, and think deeply about the difference, but you
are going to use your bias blind spot, and assume that of course you
are right, and of course you are being reasonable, and of course your
arguments are flawless, and there's no more reason to discuss.
Accepting the possibility that there's no good reason for the
different treatment is not an option, of course, that would mean you
were wrong, and you can't.

FTR. I accept I might be wrong, and there's a good reason for this
different treatment, but I haven't seen any.

Cheers.

-- 
Felipe Contreras
