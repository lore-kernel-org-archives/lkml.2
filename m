Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2GZPRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:17:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37042 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2GZPRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:17:14 -0400
Message-ID: <50115F74.2040706@linaro.org>
Date: Thu, 26 Jul 2012 16:17:08 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-21-git-send-email-lee.jones@linaro.org> <20120726115055.GD3099@opensource.wolfsonmicro.com> <50114D71.9060700@linaro.org> <20120726142825.GK3099@opensource.wolfsonmicro.com> <50115BBA.2020400@linaro.org> <20120726151404.GP3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726151404.GP3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 16:14, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 04:01:14PM +0100, Lee Jones wrote:
>
>> This is the only value which the user can pick an obscure value,
>> such as 913, thinking they can pick 913mV. I'm happy to fall-back,
>> as long as Ola is too.
>
> Erroring out if they pick an invalid value is fine, I'm more concerned
> with the case where no property is supplied at all.

Hmmm... I'll have a think.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
