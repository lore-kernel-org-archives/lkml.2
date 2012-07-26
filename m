Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2GZNvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:51:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55521 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2GZNvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:51:13 -0400
Message-ID: <50114B4D.3030305@linaro.org>
Date: Thu, 26 Jul 2012 14:51:09 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 16/21] ASoC: Ux500: Enable MOP500 driver for Device Tree
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-17-git-send-email-lee.jones@linaro.org> <20120726113734.GZ3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726113734.GZ3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 12:37, Mark Brown wrote:> On Thu, Jul 26, 2012 at 11:28:49AM +0100, Lee Jones wrote:
> 
>>   arch/arm/mach-ux500/board-mop500-msp.c |    3 ---
>>   sound/soc/ux500/mop500.c               |   41 ++++++++++++++++++++++++++++++++
> 
> There is no binding documentation here.  All bindings should be
> documented.

Yes I know. This is more of an RFC _before_ I waste my time writing documentation (again).

>> -	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
>> -	platform_device_register(&snd_soc_mop500);
>> -
> 
> This should be done separately - if it's going to be merged with
> something it should be the patch that adds the relevant DT fragments.

Yes, I can do that.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
