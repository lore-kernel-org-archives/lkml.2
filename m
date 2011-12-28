Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1L1VOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:14:00 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65061 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1L1VNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:13:54 -0500
Message-ID: <4EFB851F.9080805@solonet.org.ua>
Date: Wed, 28 Dec 2011 23:07:43 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Joe Perches'" <joe@perches.com>
Subject: Re: [PATCH v4] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib. Fix error disabling pull during probe.
References: <4EE7E0E7.1020802@solonet.org.ua> <063a01ccbfac$498513c0$dc8f3b40$%kim@samsung.com>
In-Reply-To: <063a01ccbfac$498513c0$dc8f3b40$%kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 08:46 AM, Kukjin Kim wrote:
> Denis Kuzmenko wrote:
>>
>> Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during
>> probe.
>>
>> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 
> Richard, I think, this should be handled in your tree.

ping Richard


-- 
Best regards, Denis Kuzmenko.
