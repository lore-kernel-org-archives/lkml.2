Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2KEO1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:27:11 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35170 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab2KEO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:27:09 -0500
MIME-Version: 1.0
In-Reply-To: <20121022133003.GF4477@opensource.wolfsonmicro.com>
References: <1350909125-20189-1-git-send-email-ulf.hansson@stericsson.com>
	<20121022133003.GF4477@opensource.wolfsonmicro.com>
Date: Mon, 5 Nov 2012 15:27:08 +0100
Message-ID: <CAPDyKFqgFvY67QR8LA_KTEQwDi3o2wH=MY-D89k023-2S=ioFw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: Ux500: Fixup use of clocks
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

On 22 October 2012 15:30, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Oct 22, 2012 at 02:32:04PM +0200, Ulf Hansson wrote:
>> From: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> Make sure clocks are being prepared and unprepared as well
>> as enabled and disabled.
>
> Applied, thanks.

I can not find this patch on any "next-tree" yet. Same goes for:
"[PATCH 2/2] ASoC: Ux500: Control apb clock".

Maybe I should be more patient, but thought it make sense to send a
ping on this. :-)

Kind regards
Ulf Hansson
