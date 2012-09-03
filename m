Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab2ICL6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:58:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41417 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2ICL6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAF2Aj3j25w1Nn9O6hV+=i-j1ts_p_Ucswk_M7r04S7i5BzPkHg@mail.gmail.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
	<1345734087-21803-3-git-send-email-lee.jones@linaro.org>
	<20120831112258.GA2624@pengutronix.de>
	<20120831122323.GC5962@gmail.com>
	<CACRpkdZ=C1EV4WO2b=1YLHPNhsDsQdq7Kfnpzm8i7uGRtVjJuQ@mail.gmail.com>
	<20120903094448.GB11780@pengutronix.de>
	<20120903100656.GC5782@gmail.com>
	<CACRpkdb8owKBxawAv4LVVYx5kUgZ9cUSiQ=BV0f3Pf3bHtknuQ@mail.gmail.com>
	<CAF2Aj3j25w1Nn9O6hV+=i-j1ts_p_Ucswk_M7r04S7i5BzPkHg@mail.gmail.com>
Date: Mon, 3 Sep 2012 13:58:04 +0200
Message-ID: <CACRpkdZ5VFhrbONy=0K5MFh4e6BDFckq0yqzjQ2QkW9MgwKqBg@mail.gmail.com>
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 1:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> No, this is wrong. Platform data should not override DT.
>
> If DT is enabled and passed, it should have highest priority.

Oh is that so.

Rob: do we have a clear consensus on this? Then we should document
it in Documentation/devicetree/usage-model.txt.

(That document isn't part of the binding I believe, so we could define
Linux-specific behaviours in it.)

I always thought it was the other way around, that pdata took priority.

Usecase: hardcoded bootloader passer erroneous DT to a platform.
No way out. What to do? Override with pdata.

Yours,
Linus Walleij
