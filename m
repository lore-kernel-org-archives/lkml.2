Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2ICOd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:33:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40797 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2ICOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:33:55 -0400
Message-ID: <5044BFD1.10708@nvidia.com>
Date: Mon, 03 Sep 2012 08:33:53 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Lee Jones <lee.jones@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org> <1345734087-21803-3-git-send-email-lee.jones@linaro.org> <20120831112258.GA2624@pengutronix.de> <20120831122323.GC5962@gmail.com> <CACRpkdZ=C1EV4WO2b=1YLHPNhsDsQdq7Kfnpzm8i7uGRtVjJuQ@mail.gmail.com> <20120903094448.GB11780@pengutronix.de> <20120903100656.GC5782@gmail.com> <CACRpkdb8owKBxawAv4LVVYx5kUgZ9cUSiQ=BV0f3Pf3bHtknuQ@mail.gmail.com> <CAF2Aj3j25w1Nn9O6hV+=i-j1ts_p_Ucswk_M7r04S7i5BzPkHg@mail.gmail.com> <CACRpkdZ5VFhrbONy=0K5MFh4e6BDFckq0yqzjQ2QkW9MgwKqBg@mail.gmail.com>
In-Reply-To: <CACRpkdZ5VFhrbONy=0K5MFh4e6BDFckq0yqzjQ2QkW9MgwKqBg@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 05:58 AM, Linus Walleij wrote:
> On Mon, Sep 3, 2012 at 1:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
>> No, this is wrong. Platform data should not override DT.
>>
>> If DT is enabled and passed, it should have highest priority.

No, that's wrong. If platform data is specified, it overrides DT, so
that if the DT needs any fixup, it can be provided using platform data.

