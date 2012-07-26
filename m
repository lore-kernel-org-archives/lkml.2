Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2GZNwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:52:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50338 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2GZNwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:52:14 -0400
Message-ID: <50114B89.7070100@linaro.org>
Date: Thu, 26 Jul 2012 14:52:09 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 17/21] ASoC: Ux500: Enable ux500 PCM driver for Device
 Tree
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-18-git-send-email-lee.jones@linaro.org> <20120726113838.GA3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726113838.GA3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 12:38, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 11:28:50AM +0100, Lee Jones wrote:
>
>> Here we pass platform registration from platform code over to Device
>> Tree, when DT is enabled.
>
>> -	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
>> -	platform_device_register(&ux500_pcm);
>
> This has the same issue as your last patch...  the way you're doing
> things will break audio on all boards using this driver.

It will, why?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
