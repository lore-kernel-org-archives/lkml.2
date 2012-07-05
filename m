Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2GEHgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:36:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64055 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2GEHgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:36:44 -0400
Message-ID: <4FF54406.3000307@linaro.org>
Date: Thu, 05 Jul 2012 08:36:38 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org> <20120703123552.GC25995@sirena.org.uk> <4FF2EEA1.6080204@linaro.org> <20120703132447.GN29030@opensource.wolfsonmicro.com> <4FF2F82D.9080507@linaro.org> <20120703142123.GQ29030@opensource.wolfsonmicro.com>
In-Reply-To: <20120703142123.GQ29030@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/12 15:21, Mark Brown wrote:
> On Tue, Jul 03, 2012 at 02:48:29PM +0100, Lee Jones wrote:
>> On 03/07/12 14:24, Mark Brown wrote:
>
>>> I'm really unconvinced that instnatiating the MFD cells from device tree
>>> is in general a good idea.
>
>> Well it just doesn't work the other way.
>
> In what way does it not work?
>
>>>> See c5395e7ed8f16cc7bb72a783de68659db5aed515 for a short description
>>>> of the troubles we faced.
>
>>> $ git show c5395e7ed8f16cc7bb72a783de68659db5aed515
>>> fatal: bad object c5395e7ed8f16cc7bb72a783de68659db5aed515
>
>> Sorry, looks live I've rebased since.
>
>> 5f3fc8adeec9bb12742fbfa777fa1947deda21a2
>
> This doesn't explain any of the issues, it just says that they exist.
> My best guess would be that at least some of the issue is due to
> instantiating the MFD cells from the device tree but it's hard to say
> clearly.

I'm guessing Arnd's email answered some of the questions you had. Let me 
know of you would like me to explain it in any greater detail.

By the way, this patch has nothing to do with registering these devices 
when DT is enabled. The code already does that. This is a bug fix, to 
stop multiple registration of the ab8500 when DT is _not_ enabled.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


