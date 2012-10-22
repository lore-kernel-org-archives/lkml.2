Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2JVOHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:07:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35389 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab2JVOHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121022133200.GG4477@opensource.wolfsonmicro.com>
References: <1350909125-20189-1-git-send-email-ulf.hansson@stericsson.com>
	<1350909125-20189-2-git-send-email-ulf.hansson@stericsson.com>
	<20121022133200.GG4477@opensource.wolfsonmicro.com>
Date: Mon, 22 Oct 2012 16:07:18 +0200
Message-ID: <CAPDyKFpUTjkc3rm4iDCioiiB9=EWbtqv+UQFsJRzBBv+SV7A_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: Ux500: Control apb clock
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2012 15:32, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Oct 22, 2012 at 02:32:05PM +0200, Ulf Hansson wrote:
>> From: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> When switching to common clock driver for ux500 this clock needs to
>> be handled as well. Before this clock was internally managed by the
>> clock driver itself.
>
> Applied but why isn't this a deficiency in the common clock
> implementation for the platform?

Good question. :-) Patches have just been sent to Mike Turquette clk
tree for adding the clock lookups.
First, I thought I might wanted to group them all in a series but
decided that splitting them are probably easier to handle.

Kind regards
Ulf Hansson
