Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3AJNcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:32:01 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:51418 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3AJNb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:31:59 -0500
Message-ID: <50EEC2C6.9070109@free-electrons.com>
Date: Thu, 10 Jan 2013 14:31:50 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] gpio: pca953x: add support for pca9505
References: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com> <1357493688-25061-3-git-send-email-gregory.clement@free-electrons.com> <CACRpkdYu63TZDpHrGkg0cdqFCrVH1PiNFX8FcrxB9S_Vk9r=kg@mail.gmail.com>
In-Reply-To: <CACRpkdYu63TZDpHrGkg0cdqFCrVH1PiNFX8FcrxB9S_Vk9r=kg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 12:15 PM, Linus Walleij wrote:
> On Sun, Jan 6, 2013 at 6:34 PM, Gregory CLEMENT
> <gregory.clement@free-electrons.com> wrote:
> 
>> Now that pca953x driver can handle GPIO expanders with more than 32
>> bits this patch adds the support for the pca9505 which cam with 40
>> GPIOs.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> 
> Applied, thanks.
> 
Hello Linus,

I think it is a little too early to apply this patch because the 1st
one still have bug and is not yet applied.

So it should be better to wait for that the 1st patch is fine.

Thanks.

> Yours,
> Linus Walleij
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
