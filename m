Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016Ab2CFKtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:49:18 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54586 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968Ab2CFKtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:49:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.190.8 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120306100012.GC19635@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<20120229235147.GM8295@opensource.wolfsonmicro.com>
	<CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
	<20120302125819.GE3230@opensource.wolfsonmicro.com>
	<CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
	<20120306100012.GC19635@opensource.wolfsonmicro.com>
Date: Tue, 6 Mar 2012 19:49:16 +0900
Message-ID: <CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012　19:00 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> This is not the case.  As I have *REPEATEDLY* told you you should be
> sumbitting code against current development versions of the subsystem.
You are right. v3.3-rc6 uses it. sorry for inconvenience.

>> >> +static int ml26124_update_bits(struct snd_soc_codec *codec, unsigned short reg,
>> >> +                             unsigned int mask, unsigned int value)
>> > Why are you open coding this in your driver?  There is no point in
>> > replicating subsystem functionality.
>>
>> For ML26124 spec, it's necessary.
>> Because the codec's register read-address and write-address is not the same.
>> E.G.
>> Sampling Rate Register
>> R: offset=0
>> W: offset=1
>
> This is not what the above prototype says, the above prototype has only
> one register in it.  You need to make this *much* clearer for the
> registers it's affecting.
Sorry, I couldn't understand your saying / concern.
Do you mean I shouldn't use ml26124_update_bits() but snd_soc_update_bits() ?

thanks,
-- 
ROHM Co., Ltd.
tomoya
