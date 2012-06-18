Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2FRIcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:32:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56585 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2FRIcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:32:52 -0400
Message-ID: <4FDEE7B0.9070208@linaro.org>
Date: Mon, 18 Jun 2012 09:32:48 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Walleij <linus.walleij@linaro.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 06/14] mfd: Initialise the DB8500 PRCMU driver at core_initcall
 time
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <201206121259.38807.arnd@arndb.de> <4FD742C9.7090603@linaro.org> <201206121449.22978.arnd@arndb.de>
In-Reply-To: <201206121449.22978.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/12 15:49, Arnd Bergmann wrote:
> On Tuesday 12 June 2012, Lee Jones wrote:
>> But your suggestion above involves some heavy refactoring of how Device
>> Tree works. Meanwhile the ab8500 will not work as an IRQ controller
>> until we either complete the work or use the same solution as we did for
>> the Nomadik GPIO controller. I think for now at least we should continue
>> to work on enablement and leave the 'nice to have's until last. We are
>> doing nothing new here, just bringing the ab8500 IRQ controller into
>> line with the Nomadik one.
>
> Right, I didn't say we should not take your patch, but we should be
> aware that it's not the solution we want to use in the long run.

So is it only for this and the other one to go in now?

If so, can I have acks for them please, so I may place them in my 
up-coming pull-request?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
