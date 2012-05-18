Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030431Ab2ERW43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:56:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46362 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab2ERW41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:56:27 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
To: Olof Johansson <olof@lixom.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-sh@vger.kernel.org,
        horms@verge.net.au, lethal@linux-sh.org
In-Reply-To: <CAOesGMi8LPO=AFSshC8UyCmBB3hG38YKHWnHmcNCnLvgR2xcTw@mail.gmail.com>
References: <20120515154333.6659.66479.sendpatchset@w520> <201205162205.09082.rjw@sisk.pl> <CAOesGMjgBWxjAvMpcxWsJf7n3q90sGhccUSgfGxJQA+tfDZBHw@mail.gmail.com> <201205170037.34305.rjw@sisk.pl> <CAOesGMi8LPO=AFSshC8UyCmBB3hG38YKHWnHmcNCnLvgR2xcTw@mail.gmail.com>
Date: Fri, 18 May 2012 16:56:25 -0600
Message-Id: <20120518225625.28C643E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 15:54:16 -0700, Olof Johansson <olof@lixom.net> wrote:
> On Wed, May 16, 2012 at 3:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, May 17, 2012, Olof Johansson wrote:
> >> On Wed, May 16, 2012 at 1:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Wednesday, May 16, 2012, Linus Walleij wrote:
> >> >> On Wed, May 16, 2012 at 12:15 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> >> >>
> >> >> > Do you guys have any preferences how to merge this?
> >> >> >
> >> >> > Can I include it together with the EMEV2 SoC bits perhaps? That may be
> >> >> > easy so we can keep track of the platform data header file dependency.
> >> >>
> >> >> For ux500 I made a special "gpio and pins" branch and sent through ARM SoC.
> >> >
> >> > The problem is we have a patch depending on the $subject one in the EMEV2
> >> > series and it would be better to keep them both together if that's not
> >> > a big deal.
> >>
> >> Dependencies are fine, as long as they are not circular. You can
> >> either pull in the gpio/pins branch into the EMEV2 branch, or base it
> >> on it.
> >
> > I guess I'll try to merge the gpio/pins into the EMEV2 branch.
> 
> By the way, I should have mentioned that if the dependencies are only
> for building and not for context when applying patches, then it's
> sufficient to let us know in the pull request so we merge the branches
> in the right order when sending to Linus (so we maintain
> bisectability).

Really?  I don't think that works. The actually commit point will
always be unbuildable regardless of the merge order in mainline.  If
there is a dependency then the dependency must be merged into the
working branch before applying the commit.

g.

