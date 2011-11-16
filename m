Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1KPISN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:18:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41174 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1KPISM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:18:12 -0500
Message-ID: <4EC371FE.5010402@solonet.org.ua>
Date: Wed, 16 Nov 2011 10:19:10 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: add flags to export GPIOs when requesting
References: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de> <4EC2F035.3060705@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740805F1A@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805F1A@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 11/16/2011 01:32 AM, Stephen Warren wrote:
> Denis Kuzmenko wrote at Tuesday, November 15, 2011 4:05 PM:
>> Hi Wolfram,
>> On 11/16/2011 12:44 AM, Wolfram Sang wrote:
>>
>> #define GPIOF_EXPORT			(1 << 2)
>> #define GPIOF_EXPORT_DIR_CHANGEABLE	(3 << 2)
> 
> Then you won't have a single flag to check if the dir is changeable.
> 
> Personally, I'd go for the two single-bit flags, and force boards to OR
> them together if they want the GPIO exported and with a changeable
> direction; just get rid of the two _DIR_ flags. That said, Wolfram's
> patch seems to follow the conventions already in the file.

Your truth.

> Dong Aisheng posted patch "gpio: introduce gpio_export_array to ease
> export for gpio arrays". Which should we pick; it doesn't seem like we
> need both mechanisms.

I vote for GPIOF_* variant (this one) since it can deal with different
settings for each gpio pin in array.

-- 
Best regards, Denis Kuzmenko.
