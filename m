Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2DSRWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:22:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34844 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2DSRWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120418143839.GB30966@shlinux2.ap.freescale.net>
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>
	<4F8C42D6.2000607@wwwdotorg.org>
	<20120417034210.GD17173@shlinux2.ap.freescale.net>
	<CACRpkdYH06_kGbSdozKPWZcOG0FvoOyHvjHwhz-xUL1pfSX9DQ@mail.gmail.com>
	<20120418122832.GP20478@pengutronix.de>
	<CACRpkdZw6iv=PjvvU4s5L8yV6813gCD7t8Vk-S66v-nXPaf+=Q@mail.gmail.com>
	<20120418140046.GU3852@pengutronix.de>
	<20120418143839.GB30966@shlinux2.ap.freescale.net>
Date: Thu, 19 Apr 2012 19:22:44 +0200
Message-ID: <CACRpkdbPG3eNJ0aYv_C=94wqjswV0Ycx0fKrj3jrcDge=EawMQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 4:38 PM, Dong Aisheng
<aisheng.dong@freescale.com> wrote:
> On Wed, Apr 18, 2012 at 10:00:46PM +0800, Sascha Hauer wrote:

>> Create a pinctrl_provide_dummies() functions which boards can call when
>> they do not have pinctrl support.
>>
> I think this is a feasible method and do better than Kconfig but it also
> needs more changes.

If you are both happy with this (and I suspect Stephen can also accept
it), I'd say just do it.

Yours,
Linus Walleij
