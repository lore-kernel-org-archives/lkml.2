Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2KPP1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:27:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57474 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2KPP1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:27:33 -0500
Message-ID: <50A65B5A.2090000@ti.com>
Date: Fri, 16 Nov 2012 09:27:22 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Describe UART platform registering issues
 more accurately
References: <1352968401-6092-1-git-send-email-lee.jones@linaro.org> <201211151223.46989.arnd@arndb.de> <20121115123341.GA14476@gmail.com> <201211160936.59258.arnd@arndb.de>
In-Reply-To: <201211160936.59258.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.112.204]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/16/2012 03:36 AM, Arnd Bergmann wrote:
> On Thursday 15 November 2012, Lee Jones wrote:
>> On Thu, 15 Nov 2012, Arnd Bergmann wrote:
>>
>>> On Thursday 15 November 2012, Lee Jones wrote:
>>>> UARTs no longer require call-back information, since the reset
>>>> call-back was removed in 43b5f0d69291374f602ad8e1817f329573a59010.
>>>> The only AUXDATA dependencies remaining for UARTs are DMA settings.
>>>>
>>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>
>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>>
>>> What is the state of the DMA binding now? We originally wanted to merge
>>> it for 3.7, but that didn't work out, so I hope we can get it done for
>>> 3.8.
>>
>> It's dead. The conversation has been stale for weeks.
>>
>> Perhaps you'd like to go and poke it? :)
>>
> 
> Vinod,
> 
> is there anything you are waiting for still? Should Jon resend
> his latest patches to make sure we get them merged this time?
> 
> I have multiple people that want to send me patches for 3.8 based
> on that work, so we are running out of time now.

Vinod responded today saying it will be in for v3.8 [1].

Jon

[1] http://article.gmane.org/gmane.linux.ports.arm.omap/89502


