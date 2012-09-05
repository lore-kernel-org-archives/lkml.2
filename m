Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2IEMLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:11:03 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43085 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2IEMLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 5 Sep 2012 14:10:59 +0200
Message-ID: <CACRpkda9_qK9jrJSAYo5NDiadrX2-J5mgMapY6pp__XzanUhZA@mail.gmail.com>
Subject: Re: [PATCH 0/2] pinctrl: pinctrl-single: new type: pinctrl-single,bits
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 11:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> When configuring pinmux with pinctrl-single there could be a case when one
> register is used to configure mux for more than one pin.
> In this case the use of pinctrl-single,pins is a bit problematic since we can
> only update the whole register (restricted by the mask).
> In such a situations the pinctrl-single,bits could provide a safe way to handle
> the mux.
>
> pinctrl-single,bits takes three parameters: <reg offset, value, sub-mask>
> The sub mask is used to mask part of the register to make sure we do not change
> bits outside of the scope of this pin.
>
> The first patch in this series is to fix the previous pinctrl-since,pins
> implementation because it was not using the mask on the value which could result
> changed bits outside of the mask.

This looks sane to me, but I'd like Tony to ACK before I apply it.

Yours,
Linus Walleij
