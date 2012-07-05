Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab2GEPvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:51:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58398 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2GEPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:51:38 -0400
Message-ID: <4FF5B805.8000205@linaro.org>
Date: Thu, 05 Jul 2012 16:51:33 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <20120703132447.GN29030@opensource.wolfsonmicro.com> <20120705141329.GN4111@opensource.wolfsonmicro.com> <4FF5A61F.2050400@linaro.org> <201207051541.52261.arnd@arndb.de>
In-Reply-To: <201207051541.52261.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 16:41, Arnd Bergmann wrote:
> On Thursday 05 July 2012, Lee Jones wrote:
>>
>> On 05/07/12 15:13, Mark Brown wrote:
>>> On Thu, Jul 05, 2012 at 03:06:20PM +0100, Lee Jones wrote:
>>>> On 05/07/12 14:57, Arnd Bergmann wrote:
>>>
>>>>> The non-DT path for this is a huge mess, I'd rather focus on making
>>>>> it obsolete than trying to fix it. Other than that, I agree that
>>>>> we should be registering the ab8500 from the prcmu from both the
>>>>> DT and the non-DT case.
>>>
>>>> Ah, is that what you were saying Mark?
>>>
>>>> If so, I apologise. I thought you meant register both from platform
>>>> code. I'm happy to register the AB8500 from the DB8500 for both DT
>>>> and !DT.
>>>
>>> Yes, that's what I was trying to say - sorry that I wasn't clear!
>>
>> Well it seems silly of me just to copy Arnd's work. Do you want to
>> author and submit the patch to do this Arnd?
>
> No, just assume ownership of it. I haven't tried building the
> patch, so I assume you will have to change it some more. Just
> list me as Suggested-by:.

It'll have to wait until tomorrow now, but okay, I'll take it on.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


