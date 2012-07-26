Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2GZLgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:36:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57055 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2GZLgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:36:45 -0400
Message-ID: <50112BC9.1070100@linaro.org>
Date: Thu, 26 Jul 2012 12:36:41 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 00/21] Some fixes and DT enablement for ux500 audio
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org> <20120726112848.GX3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726112848.GX3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 12:28, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 11:28:33AM +0100, Lee Jones wrote:
>> This patch-set sees some code reinforcement surrounding the recently
>> accepted MOP500 MSP, PCM, AB8500 CODEC and ux500 Audio Machine Driver.
>> It contains some extra error checking pertaining to the ux500 specific
>> drivers themselves, along with bugfixes for issues in core SoC Audio
>> code happened upon along the way. There are also a couple of minor
>> clean-ups relating to ux500 platform code, which are hitching a ride
>> for ease of status tracking.
>
> Please restructure this so that the actual error fixes (which should go
> into 3.6) are before the random cleanups (which should go into 3.7)
> rather than mixing them together.

I can.

 > It'd also be helpful if you could
> split out changes to the different subsystems separately when there's no
> overlap (which mostly looks to be the case here).

I can to this too, but you will still have overlap between arch/arm and 
sound/soc. The only other subsystem in the patch-set is MFD.




-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
