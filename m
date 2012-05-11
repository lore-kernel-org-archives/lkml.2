Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2EKRdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:33:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2EKRdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:33:01 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND v8] gpio: Device tree support for LPC32xx
To: Arnd Bergmann <arnd@arndb.de>, Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com
In-Reply-To: <201205111322.15191.arnd@arndb.de>
References: <1336679838-30738-1-git-send-email-stigge@antcom.de> <201205111219.10025.arnd@arndb.de> <4FAD0A79.8040207@antcom.de> <201205111322.15191.arnd@arndb.de>
Date: Fri, 11 May 2012 11:32:57 -0600
Message-Id: <20120511173257.98E2C3E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 13:22:14 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 11 May 2012, Roland Stigge wrote:
> > Right. Personally, I would be fine with either of my v8 (all banks in
> > dt, referenced naturally by name) and v9 (one simple DT entry for the
> > whole GPIO controller, integer index for referencing banks) patches.
> > 
> > Consider the DT-documented mapping in the latter case:
> > 
> >       0: GPIO P0
> >       1: GPIO P1
> >       2: GPIO P2
> >       3: GPIO P3
> >       4: GPI P3
> >       5: GPO P3
> > 
> > Not too difficult and would also be acceptable, IMO.
> > 
> > So Arnd and Grant, please agree one of those and pick it. :-)
> > 
> 
> Grant is maintainer for both GPIO and DT, so his opinion is what
> counts in this case.
> I was merely giving the background on how we got there so he
> can make an informed decision.

It adds a lot of boilerplate to the DT to split it up into nodes and
mapping index to a bank isn't onerous.  I think I like the single node
with #gpio-cells = <3> better.  When DTC handles named constants then
it will be even easier.

Just need to decide on the best way to implement it.  Arnd, can you
review Roland's v9 patches for me and give me your opinion?

g.
