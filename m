Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1HJGMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:12:16 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37719 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab1HJGMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:12:13 -0400
Message-ID: <4E4220B3.7020105@metafoo.de>
Date: Wed, 10 Aug 2011 08:09:55 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Mike Frysinger <vapier.adi@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [alsa-devel] [PATCH 3/4] ASoC: Blackfin: ADAU1373 eval board
 support
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>	<1312948364-2587-3-git-send-email-lars@metafoo.de> <CAHG8p1CuiJws=wSKrfAiY9E=rne=taPP-semYZQJWuHn19398w@mail.gmail.com>
In-Reply-To: <CAHG8p1CuiJws=wSKrfAiY9E=rne=taPP-semYZQJWuHn19398w@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 07:27 AM, Scott Jiang wrote:
>> +config SND_SOC_BFIN_EVAL_ADAU1373
>> +       tristate "Support for the EVAL-ADAU1373 board on Blackfin eval boards"
>> +       depends on SND_BF5XX_I2S
>> +       select SND_BF5XX_SOC_I2S
>> +       select SND_SOC_ADAU1373
>> +       select I2C
> 
> Is it better to use depends on I2C?
> 

Not sure, I just kept the scheme used by the other blackfin board drivers. But
I guess it makes some sense change it to 'depends'. Especially if we consider
that there are going to be board drivers with support for both I2C and SPI.

- Lars
