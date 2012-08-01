Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2HAHTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:19:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46863 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2HAHTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:19:32 -0400
Message-ID: <5018D880.5090306@linaro.org>
Date: Wed, 01 Aug 2012 08:19:28 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 1/6] ASoC: dapm: If one widget fails, do not force all
 subsequent widgets to fail too
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <1343741493-17671-3-git-send-email-lee.jones@linaro.org> <20120731134214.GK4468@opensource.wolfsonmicro.com> <5017EAC3.3080504@linaro.org> <20120731142820.GW4468@opensource.wolfsonmicro.com> <5017EDCA.4020601@linaro.org> <20120731145443.GY4468@opensource.wolfsonmicro.com> <5017F68B.3060400@linaro.org> <20120731151819.GC4468@opensource.wolfsonmicro.com>
In-Reply-To: <20120731151819.GC4468@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/12 16:18, Mark Brown wrote:
>>> It's certainly totally inappropriate for an "urgent" bugfix.
>
>> Well it just means that audio won't work for the ux500 for this
>> kernel release, but as we're waiting on clocks, this isn't a big
>> issue for us. If you do take it (with or without the return code),
>> feel free to add it to for-next instead of the -rc:s
>
> I'm not going to apply this patch.  This isn't a vendor BSP, we
> shouldn't be putting random hacks like this in core code.

BSP kernel or otherwise, it still seems wrong to me to fail and entire 
audio driver just because of a broken link.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
