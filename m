Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2IQI65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:58:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47570 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2IQI64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <5053668B.6020604@wwwdotorg.org>
References: <1347630587-31014-1-git-send-email-linus.walleij@stericsson.com>
	<5053668B.6020604@wwwdotorg.org>
Date: Mon, 17 Sep 2012 10:58:54 +0200
Message-ID: <CACRpkdYhy4k_JFckfYPP3ijku2O_cFQQr5810FAaje0xNr1FCw@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: document semantics vs GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 7:16 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/14/2012 07:49 AM, Linus Walleij wrote:

>> +If a pin control driver and a GPIO driver is dealing with the same pins
>> +and the use cases involve multiplexing, you MUST implement the pin controller
>> +as a back-end for the GPIO driver like this.
>
> I might add one caveat to that:
>
> ==========
> , unless your HW design is such that the GPIO controller can override
> the pin controller's mux state, without the need for any such interaction.
> ==========

OK I buy that, so added this paragraph (slightly rephrased) and pused
for next.

> In the future, I wonder if someone might want the following caveat,
>
> ==========
> , unless you require that all boards (or device trees) define a system
> hog pinmux configuration that muxes all required GPIO signals as desired.
> ==========
>
> ... which might be appropriate for HW where GPIO-vs-special-function
> selection is performed in the pinmux controller itself, per-pin. Perhaps
> this is the OMAP special case you mentioned before?

Yeah :-/

I worry about exploding complexity here, so we need to think
about this a bit more...

Linus
