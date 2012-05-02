Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2EBLbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:31:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34352 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2EBLbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:31:24 -0400
Message-ID: <4FA11B08.5060506@linaro.org>
Date: Wed, 02 May 2012 12:31:20 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120402 Thunderbird/11.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 1/3] power/ab8500_charger: harden platform data check
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com> <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
In-Reply-To: <CACRpkdaM=OecD=M_J9X9shYKQkWO03mhb2BFxCWOeocr8_m=DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/12 13:59, Linus Walleij wrote:
> On Fri, Apr 13, 2012 at 10:15 AM, Linus Walleij
> <linus.walleij@stericsson.com>  wrote:
>
>> From: Linus Walleij<linus.walleij@linaro.org>
>>
>> If no platform data at all is supplied the driver crashes,
>> extend the checks to be more careful so we can compile in the
>> driver and boot also without platform data present.
>>
>> Cc: Arun Murthy<arun.murthy@stericsson.com>
>> Signed-off-by: Linus Walleij<linus.walleij@linaro.org>
>
> Anton have you picked these three patches for the -rc:s?
>
> It seems Lee Jones is facing the problems so would be nice to
> have this upstream.

Any chance of an update for this patch-set please?

Are you taking in Linus' patches, or would you like me to submit mine?

Linus, do you have an opinion?

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
