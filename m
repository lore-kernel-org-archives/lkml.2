Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2E1Ggh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 02:36:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60658 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2E1Ggf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 02:36:35 -0400
Date: Mon, 28 May 2012 09:36:25 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Subject: Re: [RFC v7] UBI: Fastmap support (aka checkpointing)
Message-ID: <20120528093625.050badc6@pixies.home.jungo.com>
In-Reply-To: <1338036094.2525.7.camel@koala>
References: <1337771191-95358-1-git-send-email-richard@nod.at>
	<1338036094.2525.7.camel@koala>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Sat, 26 May 2012 15:41:34 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Wed, 2012-05-23 at 13:06 +0200, Richard Weinberger wrote:
> > v1: https://lwn.net/Articles/481612/
> > v2: https://lwn.net/Articles/496586/
> > v3: Didn't release it to linux-mtd
> > v4: http://article.gmane.org/gmane.linux.kernel/1297626
> > v5: http://article.gmane.org/gmane.linux.kernel/1298488
> > v6: https://lwn.net/Articles/498041/
> 
> Hi Richard,
> 
> while my daughters are sleeping, I have a chance to quickly review the
> code. I just start from the attaching path and add TODOs.
> 
> Can we change our workflow a bit. I will create a branch for fastmap in
> the UBI tree taking v7 as the base. I'll add my TODOs there and commit,
> and send them also as a patch to the mailing list. You then send
> incremental patches which fix TODOs or anything else.
> 
> We can discuss my notes and if some of them make no sens - the patch
> would just kill the TODO.
> 
> In any case, I feel a need to switch to incremental development and get
> incremental patches instead of code drops. You can send entire fastmap
> work to the list from time to time, of course, for people to look.
> 
> How does this sound?
> 
> Also, I'd like you to document the tests you do. I'd like to start
> making sure that we never break anything.
> 
> We can start with the UBI tests from the mtd-utils plust the integck
> test. And whatever goes to my branch should never break them. Do these
> tests pass now? If not, let's make them pass.
> 
> How does this sound to you?
> 
> At some later points we'll start to move pieces to the master branch.
> 
> Shmulik, is it fine with you?

Fine with me, I'm flexible ;)

What's your plan for merging to the master branch?

BTW, I know you formerly disliked the idea, but I'm in favor of having a
CONFIG for the fastmap feature; with the config disabled, UBI must
behave exactly as it was. The config can be later removed.

Update regarding status of my review:
I've reviewed fastmap's wiring up into UBI, as of v6.
I still need to review fastmap.c itself and ubi-media.h.
I focused on general correctness and addressing issues that might affect
existing UBI behavior, and less on the design itself - you can probably
shed more light in this area.

Regards,
Shmulik
