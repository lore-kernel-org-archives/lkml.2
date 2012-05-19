Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab2ESC1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 22:27:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2ESC1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 22:27:40 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <CACxGe6uNgE6Xdx965fSi8ezVts7FFiW6kuBbyEGJXkRD4eoP6Q@mail.gmail.com>
References: <20120515154333.6659.66479.sendpatchset@w520>
	<201205162205.09082.rjw@sisk.pl>
	<CAOesGMjgBWxjAvMpcxWsJf7n3q90sGhccUSgfGxJQA+tfDZBHw@mail.gmail.com>
	<201205170037.34305.rjw@sisk.pl>
	<CAOesGMi8LPO=AFSshC8UyCmBB3hG38YKHWnHmcNCnLvgR2xcTw@mail.gmail.com>
	<20120518225625.28C643E07C8@localhost>
	<CAOesGMh1VQ5BAybLEzVLqL2cOQe2CJ8CgbK+5-R4sH4iG0Kvog@mail.gmail.com>
	<CACxGe6uNgE6Xdx965fSi8ezVts7FFiW6kuBbyEGJXkRD4eoP6Q@mail.gmail.com>
Date: Fri, 18 May 2012 19:27:40 -0700
Message-ID: <CAOesGMizxoEmq948Thax=aY3JmJaMWp5HLmzJtTAJS6pOSbFdQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-sh@vger.kernel.org,
        horms@verge.net.au, lethal@linux-sh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 6:44 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> See?  Y1 shows up without the X1 parent.  With git, there is never a
> straight line history, so every commit must be fully built on top of
> all the commits it needs.  (And did I understand what you were trying
> to describe correctly?)

You understood my intentions, but I had a misconception of how bisect
actually works.

"Fighting regressions with git bisect" visualizes pretty well why
you're right and I'm wrong as well. :)


-Olof
