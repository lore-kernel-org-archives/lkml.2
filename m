Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2KQUQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 15:16:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50500 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2KQUQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 15:16:11 -0500
MIME-Version: 1.0
In-Reply-To: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com>
Date: Sat, 17 Nov 2012 21:16:10 +0100
Message-ID: <CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com>
Subject: Re: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 10:35 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> Avoid using the TWL4030_MODULE_PWMA/B as module ID. The LEDEN, PWMA ON/OFF
> and PWMB ON/OFF registers are in a continuous range starting from LED base.
> This is going to be helpful for further cleanup in the twl stack.
>
> No functional changes.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

OK if you say so.

Patch applied!

Yours,
Linus Walleij
