Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2ICOf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:35:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42876 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ICOf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <5044BFD1.10708@nvidia.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
	<1345734087-21803-3-git-send-email-lee.jones@linaro.org>
	<20120831112258.GA2624@pengutronix.de>
	<20120831122323.GC5962@gmail.com>
	<CACRpkdZ=C1EV4WO2b=1YLHPNhsDsQdq7Kfnpzm8i7uGRtVjJuQ@mail.gmail.com>
	<20120903094448.GB11780@pengutronix.de>
	<20120903100656.GC5782@gmail.com>
	<CACRpkdb8owKBxawAv4LVVYx5kUgZ9cUSiQ=BV0f3Pf3bHtknuQ@mail.gmail.com>
	<CAF2Aj3j25w1Nn9O6hV+=i-j1ts_p_Ucswk_M7r04S7i5BzPkHg@mail.gmail.com>
	<CACRpkdZ5VFhrbONy=0K5MFh4e6BDFckq0yqzjQ2QkW9MgwKqBg@mail.gmail.com>
	<5044BFD1.10708@nvidia.com>
Date: Mon, 3 Sep 2012 16:35:55 +0200
Message-ID: <CACRpkda0akcLRe3J=fVcyYpxHmkJmVe+c1doXQ4=vOA6iNxe2g@mail.gmail.com>
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        linus.walleij@stericsson.com, Wolfram Sang <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 4:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
> On 09/03/2012 05:58 AM, Linus Walleij wrote:
>> On Mon, Sep 3, 2012 at 1:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>>> No, this is wrong. Platform data should not override DT.
>>>
>>> If DT is enabled and passed, it should have highest priority.
>
> No, that's wrong. If platform data is specified, it overrides DT, so
> that if the DT needs any fixup, it can be provided using platform data.

Thanks Stephen, now there are two of us saying this, Lee please
follow this design pattern.

(Unless Rob/Grant start shouting counter-orders...)

Yours,
Linus Walleij
