Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab2DOEDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 00:03:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59457 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2DOEDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 00:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120414135331.GB3852@pengutronix.de>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
	<1334333915-1174-3-git-send-email-b29396@freescale.com>
	<20120414135331.GB3852@pengutronix.de>
Date: Sun, 15 Apr 2012 12:03:16 +0800
Message-ID: <CAA+hA=QhSUZg0bWTss_4ROwZ--OOQfcP=mpt+MP7-ZKPkEwXyA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: imx6q: switch to use pinctrl driver
From: Dong Aisheng <dongas86@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 9:53 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Sat, Apr 14, 2012 at 12:18:35AM +0800, Dong Aisheng wrote:
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> ---
>> This patch is used for test the new pinctrl driver.
>
> Then please test it with i.MX35, i.MX5...
>
>>
>> +     imx_data->p = pinctrl_get_select_default(&pdev->dev);
>> +     if (IS_ERR(imx_data->p)) {
>> +             err = PTR_ERR(imx_data->p);
>> +             goto pin_err;
>> +     }
>> +
>
> ... which will fail here.
Sorry, it will not work, it's not a formal patch.
I just sent it quickly for users to try on imx6q.
For MX3 and MX5, before their pinctrl driver are available, user may
need to define a dummy in dt to avoid such an error.

Regards
Dong Aisheng
