Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab2GJSTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 14:19:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57681 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2GJSTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 14:19:31 -0400
Message-ID: <4FFC722E.2020303@linaro.org>
Date: Tue, 10 Jul 2012 20:19:26 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 1/1] mfd: ab8500: Clean-up the last two ab8500 related
 DT match tables
References: <1341578598-9307-1-git-send-email-lee.jones@linaro.org> <20120710091304.GU15345@sortiz-mobl> <4FFC4A23.5000107@linaro.org> <20120710165518.GG15345@sortiz-mobl>
In-Reply-To: <20120710165518.GG15345@sortiz-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/12 18:55, Samuel Ortiz wrote:
> Hi Lee,
>
> On Tue, Jul 10, 2012 at 05:28:35PM +0200, Lee Jones wrote:
>> On 10/07/12 11:13, Samuel Ortiz wrote:
>>> Hi Lee,
>>>
>>> On Fri, Jul 06, 2012 at 01:43:18PM +0100, Lee Jones wrote:
>>>> A patch was recently submitted to stop all ab8500 devices from
>>>> being registered through Device Tree. Instead, only the db8500
>>>> will be DT:ed and the rest will continue to be registered via
>>>> the MFD API, as they always were.
>>>>
>>>> Two patches have recently been applied which enable Device Tree
>>>> probing; one for rtc-ab8500 and the other for ponkey-ab8500.
>>>> These two need to be removed to prevent double-probing these
>>>> devices with Device Tree is enabled.
>>>>
>>>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>> ---
>>>>   drivers/input/misc/ab8500-ponkey.c |    8 --------
>>>>   drivers/rtc/rtc-ab8500.c           |    6 ------
>>>>   2 files changed, 14 deletions(-)
>>> I don't know against which tree you generated those patches, but none of those
>>> 2 of_device_id arrays are in my for-next branch. So I can't apply this patch.
>>
>> I can rebase them on anything of your choosing.
>>
>> What is your for-next branch based on?
> On Linus' tree. And the of_device_id arrays are not there.

Ah, that's why.

These are patches based on the -next tree.

The code we adapt here isn't in Mainline yet.

I can wait and send them in the back-end of the merge window, or -rc1 
instead?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


