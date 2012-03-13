Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030361Ab2CMKS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:18:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43099 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030345Ab2CMKSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYB4ambuDeMUX1kZn793xxfaaNjQ56EB4C8OAykMxoPJQ@mail.gmail.com>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdYB4ambuDeMUX1kZn793xxfaaNjQ56EB4C8OAykMxoPJQ@mail.gmail.com>
Date: Tue, 13 Mar 2012 15:48:24 +0530
Message-ID: <CAJuYYwSUepRJuwdtDUGu6frCsHvvtmDEUrXEHKitYJppWwL0aw@mail.gmail.com>
Subject: Re: [PATCH 0/5] pinctrl: add new Samsung pinctrl driver and add
 Exynos4 support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2012 15:43, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sun, Mar 11, 2012 at 1:46 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> This patch series adds new pinctrl driver for Samsung SoC's. The driver supports
>> a gpiolib interface as well since Samsung SoC's have a combined pinmux/pinctrl
>> and gpio controller.
>
> Overall this all looks good to me Thomas!
> I will provide detailed review if/when it is more ripe for merge.

Thanks linus for having a look. The missing bits in the driver are
wakeup interrupt and gpio interrupt support. Without these, it would
not be possible to meaningfully demonstrate a fully functional system
using the pinctrl and gpiolib driver for Exynos4.

Regards,
Thomas.

>
> Yours,
> Linus Walleij
