Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab2JWKEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:04:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32903 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2JWKED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <508664CA.7000601@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
	<CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
	<508664CA.7000601@ti.com>
Date: Tue, 23 Oct 2012 12:04:01 +0200
Message-ID: <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 11:35 AM, Benoit Cousson <b-cousson@ti.com> wrote:
> On 10/23/2012 11:13 AM, Linus Walleij wrote:

>> So Sourav, please tell us a bit about your plans for this
>> and other drivers!
>
> Yeah, this idea is to handle pinctrl from all the drivers, and
> potentially change the mode during suspend when it is relevant.

I'm leaning toward the same approach for ux500.

But it appears that shmobile prefer to get all resources using
bus notifiers.

So we need to form some kind of consensus ... or live with
the fact that different systems do it different ways. Which will
explode the day we need to use a driver on two systems,
each using the other approach :-)

Yours,
Linus Walleij
