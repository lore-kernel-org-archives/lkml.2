Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2GZQFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:05:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41100 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2GZQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:05:54 -0400
Message-ID: <50116ADF.4050700@linaro.org>
Date: Thu, 26 Jul 2012 17:05:51 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 07/21] ASoC: io: Prevent use of regmap if request fails
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <1343298534-13611-8-git-send-email-lee.jones@linaro.org> <20120726113204.GY3099@opensource.wolfsonmicro.com> <50112C29.6020606@linaro.org> <20120726114215.GB3099@opensource.wolfsonmicro.com> <50115961.6060509@linaro.org> <20120726151217.GO3099@opensource.wolfsonmicro.com> <501160F5.5050807@linaro.org> <20120726152533.GS3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726152533.GS3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 16:25, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 04:23:33PM +0100, Lee Jones wrote:
>
>> What's my 'control data'? It's not used in the original codec patch.
>
>> The old way wants to go:
>
>> snd_soc_update_bits() -> snd_soc_read() -> ab8500_codec_read_reg()
>
>> When then calls back into the abx500.
>
>> So what 'control data' should I be storing in the codec struct?
>
> You're supposed to use it for the data you use to call back into the
> underlying I/O code.

I don't understand. What 'data'?

Surely if .read and .write are populated in 'struct 
snd_soc_codec_driver', then it should just call back into those?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
