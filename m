Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab0GOJRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:17:16 -0400
Received: from mail-ww0-f66.google.com ([74.125.82.66]:42691 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab0GOJRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:17:14 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimEdVsmIgXBbmhsq75ElQvGAI8avsM8-wlDpm4z@mail.gmail.com>
References: <201007110918.42120.Martin@lichtvoll.de>
	<AANLkTimEdVsmIgXBbmhsq75ElQvGAI8avsM8-wlDpm4z@mail.gmail.com>
Date: Thu, 15 Jul 2010 10:09:03 +0100
Message-ID: <AANLkTimgwxdEyZGGnW1pvNFkRNaDyBtJegD_eIC9oit4@mail.gmail.com>
Subject: Re: stable? quality assurance?
From: Valeo de Vries <valeo@valeo.co.cc>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Martin <Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2010 08:18, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> Hi!
>
> 2.6.34 was a desaster for me: bug #15969 - patch was availble before
> 2.6.34 already, bug #15788, also reported with 2.6.34-rc2 already, as well
> as most important two complete lockups - well maybe just X.org and radeon
> KMS, I didn't start my second laptop to SSH into the locked up one - on my
> ThinkPad T42. I fixed the first one with the patch, but after the lockups I
> just downgraded to 2.6.33 again.
>
> I still actually *use* my machines for something else than hunting patches
> for kernel bugs and on kernel.org it is written "Latest *Stable* Kernel"
> (accentuation from me). I know of the argument that one should use a
> distro kernel for machines that are for production use. But frankly, does
> that justify to deliver in advance known crap to the distributors? What
> impact do partly grave bugs reported on bugzilla have on the release
> decision?
>
> And how about people who have their reasons - mine is TuxOnIce - to
> compile their own kernels?
>
> Well 2.6.34.1 fixed the two reported bugs and it seemed to have fixed the
> freezes as well. So far so good.
>
> Maybe it should read "prerelease of stable" for at least 2.6.34.0 on the
> website. And I just again always wait for .2 or .3, as with 2.6.34.1 I
> still have some problems like the hang on hibernation reported in
>
> hang on hibernation with kernel 2.6.34.1 and TuxOnIce 3.1.1.1
>
> on this mailing list just a moment ago. But then 2.6.33 did hang with
> TuxOnIce which apparently (!) wasn't a TuxOnIce problem either, since
> 2.6.34 did not hang with it anymore which was a reason for me to try
> 2.6.34 earlier.
>
> I am quite a bit worried about the quality of the recent kernels. Some
> iterations earlier I just compiled them, partly even rc-ones which I do
> not expact to be table, and they just worked. But in the recent times .0,
> partly even .1 or .2 versions haven't been stable for me quite some times
> already and thus they better not be advertised as such on kernel.org I
> think. I am willing to risk some testing and do bug reports, but these are
> still production machines, I do not have any spare test machines, and
> there needs to be some balance, i.e. the kernels should basically work.
> Thus I for sure will be more reluctant to upgrade in the future.

Ooh, it's been a while since I've partaken in a LKML flamewar. ;-)

On a slightly less childish note, I agree with a few of your points. I have
noticed *stable* releases (I'm talking distro kernels here) being less than
stable on occasion recently (the sporadic hard lock-up, bdi-writeback
taking damn long, the recent 'umount with dirty buffers taking an ice-age
to complete' bug). Additionally there seems to have been some very
chunky point-releases in the last 3-6 months, many containing patches
that really should have been kept for the next Linus kernel.org kernel, IMO.
These annoyances drove me away from Linux for a good few months... it's
amazing what working full-time with Windows can do to one's soul, though!

That said, from what I've seen of late, there's only one guy (Greg) handling
most of the stable stuff (there are probably others working behind the
scenes), and he has a hell of a lot on his plate. So if you, like me, want to
see more reliable stable releases, I'd recommend either offering to help out
in some way reviewing/testing stable patches, as telling volunteers their shit
doesn't tend to gain you much at all, generally. :-)

Valeo
