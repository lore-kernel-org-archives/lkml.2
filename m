Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2CIG03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:26:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58747 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2CIG02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:26:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120308110548.GG3638@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<1329976011-2251-2-git-send-email-tomoya.rohm@gmail.com>
	<20120302163915.GD6056@opensource.wolfsonmicro.com>
	<CANKRQni8hPoHEsV2VecbgKBdfS5+rit0-jXzz_d8F_nY5-dN3g@mail.gmail.com>
	<20120306115246.GD19635@opensource.wolfsonmicro.com>
	<CANKRQngg+8LJvb-+Byv6XPqqWFyCU1U+-hppuxo_=CM1qLUF_Q@mail.gmail.com>
	<20120307114631.GE3107@opensource.wolfsonmicro.com>
	<CANKRQnh2x-EYyaiOaz58zBeAe7PKWNS6cE+yyha5jSvignigHw@mail.gmail.com>
	<20120308110548.GG3638@opensource.wolfsonmicro.com>
Date: Fri, 9 Mar 2012 15:26:27 +0900
Message-ID: <CANKRQngo_Wz-5XqdYe9TWe2QhmVgUTZc3TRajFT+CLjvEAWVdA@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 8:05 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > You've still not explained the problem you're seeing but this sounds
>> > like something that should work.  Please address the
>> * Faced problem if there are no platform settings.
>> machine driver's hw_params is not called
>> platform_driver's functions(snd_pcm_ops, snd_soc_platform_driver) are
>> not called.
>> As a result, the following message is not showed . (by soc_pcm.c)
>> printk(KERN_INFO "asoc: %s <-> %s mapping ok\n", codec_dai->name,
>>          cpu_dai->name);
> This makes no sense.  Registering a platform device will have *no*
> impact on ASoC, it only cares if the relevant ASoC function drivers have
> come up.  Probably there was some other problem with what you were doing
> but it's hard to say...

I've confirmed that driver detected by ASoC correctly without these
platform functions.
Please check next patch series.

thanks.
-- 
ROHM Co., Ltd.
tomoya
