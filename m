Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2ILGFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:05:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60318 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab2ILGE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <504FB869.60201@wwwdotorg.org>
References: <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347266386-16229-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<20120911164409.4c030bd8@skate>
	<504FB869.60201@wwwdotorg.org>
Date: Wed, 12 Sep 2012 08:04:57 +0200
Message-ID: <CACRpkdZf7YO4+aY42JK4OhhTSDCxN+hNjG+xVeyJ7QHsuaqh5A@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] pinctrl: mvebu: pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 12:17 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> the drivers in this patch seem to invert the data-structures a
> little - in other words, instead of defining a global list of functions,
> they define a list of groups, and for each group, list the functions
> that can be selected on to it.
>
> In turn, that probably requires the core mvebu driver to invert these
> data-structures at run-time in order to provide the data the pinctrl
> core needs. I think it'd be better to just have each SoC-specific driver
> store the data tables in the same format that the pinctrl core needs it,
> so that the mvebu pinctrl core won't have to process the data-structures
> at all.

I sort of agree, not a blocker from my side but it'll surely make the
code easier to maintain.

Else I think the culprit function needs some commenting to be
readable, and writing in plaintext what can be explained by
simpler code is not good...

Yours,
Linus Walleij
