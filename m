Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2LMIUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:20:02 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:45771 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab2LMIT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:19:58 -0500
Message-ID: <50C98F68.4020107@stericsson.com>
Date: Thu, 13 Dec 2012 09:18:48 +0100
From: Julien DELACOU <julien.delacou@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111110 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Subject: Re: [PATCH 1/2] pinctrl: add sleep mode management for hogs
References: <1355234393-17368-1-git-send-email-linus.walleij@stericsson.com> <50C7A194.7070102@wwwdotorg.org> <CACRpkdak+f8Nnyns+jdGsxrzD1839-kdOqySChD9aDG+7KMU7Q@mail.gmail.com>
In-Reply-To: <CACRpkdak+f8Nnyns+jdGsxrzD1839-kdOqySChD9aDG+7KMU7Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 08:31 PM, Linus Walleij wrote:
> On Tue, Dec 11, 2012 at 10:11 PM, Stephen Warren<swarren@wwwdotorg.org>  wrote:
>
>> Since I assume those function are only supposed to be used by pinctrl
>> drivers themselves, should the prototypes go into drivers/pinctrl/core.h
>> or similar, rather than something in include/linux/pinctrl?
> Good point, Julien can you fix this?
Sure, I will.
>
> Hm, maybe pinctrl_force_sleep()/default() isn't such a good name,
> maybe it should be pinctrl_hogs_sleep()/pinctrl_hogs_default() intead?
>
>> Oh, and don't you need EXPORT_SYMBOL in case the pinctrl driver is a module?
> True.
I will do it too.
>
>> Aside from that,
>>
>> Reviewed-by: Stephen Warren<swarren@nvidia.com>
> Thanks.
>
> Yours,
> Linus Walleij
Thanks a lot.

Regards,
Julien

