Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab2GEOfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:35:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44905 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2GEOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:35:14 -0400
Message-ID: <4FF5A61F.2050400@linaro.org>
Date: Thu, 05 Jul 2012 15:35:11 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <20120703132447.GN29030@opensource.wolfsonmicro.com> <4FF58B68.5000703@linaro.org> <20120705124549.GD4111@opensource.wolfsonmicro.com> <201207051357.07195.arnd@arndb.de> <4FF59F5C.8050002@linaro.org> <20120705141329.GN4111@opensource.wolfsonmicro.com>
In-Reply-To: <20120705141329.GN4111@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 15:13, Mark Brown wrote:
> On Thu, Jul 05, 2012 at 03:06:20PM +0100, Lee Jones wrote:
>> On 05/07/12 14:57, Arnd Bergmann wrote:
>
>>> The non-DT path for this is a huge mess, I'd rather focus on making
>>> it obsolete than trying to fix it. Other than that, I agree that
>>> we should be registering the ab8500 from the prcmu from both the
>>> DT and the non-DT case.
>
>> Ah, is that what you were saying Mark?
>
>> If so, I apologise. I thought you meant register both from platform
>> code. I'm happy to register the AB8500 from the DB8500 for _both_ DT
>> and !DT.
>
> Yes, that's what I was trying to say - sorry that I wasn't clear!

Well it seems silly of me just to copy Arnd's work. Do you want to 
author and submit the patch to do this Arnd?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


