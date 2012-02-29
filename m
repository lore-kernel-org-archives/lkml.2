Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2B2TmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:42:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55760 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2B2TmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:42:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF2125@HQMAIL01.nvidia.com>
References: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
	<CACRpkdaaYF8UqweNm6sQ3dke9J76J2oY62BPBSisPo9myf7W4g@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BDDF209D@HQMAIL01.nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BDDF2125@HQMAIL01.nvidia.com>
Date: Wed, 29 Feb 2012 20:42:21 +0100
Message-ID: <CACRpkdbHngH1DNTMYaZSfqy5ySkuZyu1mZ30tmWTmyuBGK-Few@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT, define
 hogs as that state
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 8:21 PM, Stephen Warren <swarren@nvidia.com> wrote:

> Actually, it looks very easy to move the func_selector field out of
> struct pinctrl into struct pinmux_group, which would solve this problem
> in what I consider the correct way. I'll code up a patch to do that and
> stack it before this current patch.

Hm that sounds really elegant, go for it!

Yours,
Linus Walleij
