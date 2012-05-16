Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706Ab2EPWcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:32:39 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab2EPWci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:32:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
Date: Thu, 17 May 2012 00:37:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-sh@vger.kernel.org,
        horms@verge.net.au, grant.likely@secretlab.ca, lethal@linux-sh.org
References: <20120515154333.6659.66479.sendpatchset@w520> <201205162205.09082.rjw@sisk.pl> <CAOesGMjgBWxjAvMpcxWsJf7n3q90sGhccUSgfGxJQA+tfDZBHw@mail.gmail.com>
In-Reply-To: <CAOesGMjgBWxjAvMpcxWsJf7n3q90sGhccUSgfGxJQA+tfDZBHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205170037.34305.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2012, Olof Johansson wrote:
> On Wed, May 16, 2012 at 1:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, May 16, 2012, Linus Walleij wrote:
> >> On Wed, May 16, 2012 at 12:15 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> >>
> >> > Do you guys have any preferences how to merge this?
> >> >
> >> > Can I include it together with the EMEV2 SoC bits perhaps? That may be
> >> > easy so we can keep track of the platform data header file dependency.
> >>
> >> For ux500 I made a special "gpio and pins" branch and sent through ARM SoC.
> >
> > The problem is we have a patch depending on the $subject one in the EMEV2
> > series and it would be better to keep them both together if that's not
> > a big deal.
> 
> Dependencies are fine, as long as they are not circular. You can
> either pull in the gpio/pins branch into the EMEV2 branch, or base it
> on it.

I guess I'll try to merge the gpio/pins into the EMEV2 branch.

Thanks,
Rafael
