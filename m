Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab2E3PBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:01:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55128 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2E3PBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:01:11 -0400
Message-ID: <4FC63632.4030504@linaro.org>
Date: Wed, 30 May 2012 23:01:06 +0800
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org> <1338353260-10097-9-git-send-email-lee.jones@linaro.org> <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com> <20120530100302.GD9947@opensource.wolfsonmicro.com> <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com> <20120530121547.GJ9947@opensource.wolfsonmicro.com>
In-Reply-To: <20120530121547.GJ9947@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/12 20:15, Mark Brown wrote:
> On Wed, May 30, 2012 at 07:40:49PM +0800, Lee Jones wrote:
>> On May 30, 2012 6:03 PM, "Mark Brown"<broonie@opensource.wolfsonmicro.com>
>
>>> If we are changing the names then not including the ab8500 bit would
>>> seem more idiomatic - we've already worked out which chip this is by the
>>> time we're looking here.
>
>> No, Linus had the wrong end of the stick. I've just spoken to him in person.
>
>> Those are not the names of the regulators. They're the names of the Device
>> Tree nodes. The regulator names shall remain the same.
>
> Fair enough.  My point about the ab8500_ bit still stands though.

It's a Device Tree thing. I do it so we can easily see which regulator 
is driving which device(s).

I personally think:

	vin-supply = <&db8500_vape_reg>;
	vmmc-supply = <&ab8500_ldo_aux2_reg>;

Tells us so much more and is simpler to decrypt at a glance than 
something like:

	vin-supply = <&vape_reg>;
	vmmc-supply = <&ldo_aux2_reg>;

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
