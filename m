Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0H0GKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 02:10:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab0H0GKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 02:10:49 -0400
Date: Thu, 26 Aug 2010 23:14:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, dtor@mail.ru,
        adobriyan@gmail.com, tj@kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] UCB1400: Pass ucb1400-gpio data through ac97 bus
Message-Id: <20100826231419.fff73529.akpm@linux-foundation.org>
In-Reply-To: <201008270750.38118.marek.vasut@gmail.com>
References: <1281327394-6716-1-git-send-email-marek.vasut@gmail.com>
	<201008090643.14777.marek.vasut@gmail.com>
	<20100826160736.747f3717.akpm@linux-foundation.org>
	<201008270750.38118.marek.vasut@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 07:50:37 +0200 Marek Vasut <marek.vasut@gmail.com> wrote:

> Dne P__ 27. srpna 2010 01:07:36 Andrew Morton napsal(a):
> > On Mon, 9 Aug 2010 06:43:14 +0200
> > 
> > Marek Vasut <marek.vasut@gmail.com> wrote:
> > > Dne Po 9. srpna 2010 06:16:34 Marek Vasut napsal(a):
> > > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > 
> > Please don't send unchangelogged patches.
> 
> Unchangelogged? What do you mean ?

Patches which don't have any changelog.  This patch was sent with no
covering explanation.

> > 
> > The title tells us what the patch does but provides no hint as to why
> > it does it.

As I indicated.  The title tells us what the patch does but didn't tell
us *why* it does it.  Apparently it is preparatory work for some other
patch?

> > > > ---
> > > > 
> > > >  drivers/gpio/ucb1400_gpio.c |   19 ++++++-------------
> > > >  drivers/mfd/ucb1400_core.c  |    5 +++++
> > > >  include/linux/ucb1400.h     |   19 ++++++-------------
> > > >  3 files changed, 17 insertions(+), 26 deletions(-)
> > > 
> > > Ah right, guys, if possible, let this go through Eric Miao's tree (as I
> > > have changes that depend on this). Thanks!
> > 
> > He's probably unaware of the patch.  Let's cc him.
> 
> I have this one in my tree and I sent it to Eric as a part of larger patchset.

Recently, I assume - it wasn't in this morning's linux-next.
