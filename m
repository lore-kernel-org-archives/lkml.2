Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031273Ab2CGCQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:16:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40731 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030976Ab2CGCQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120306121222.GK19635@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<20120229235147.GM8295@opensource.wolfsonmicro.com>
	<CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
	<20120302125819.GE3230@opensource.wolfsonmicro.com>
	<CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
	<20120306100012.GC19635@opensource.wolfsonmicro.com>
	<CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
	<20120306121222.GK19635@opensource.wolfsonmicro.com>
Date: Wed, 7 Mar 2012 11:16:50 +0900
Message-ID: <CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
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

On Tue, Mar 6, 2012 at 9:12 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > This is not what the above prototype says, the above prototype has only
>> > one register in it.  You need to make this *much* clearer for the
>> > registers it's affecting.
>> Sorry, I couldn't understand your saying / concern.
>> Do you mean I shouldn't use ml26124_update_bits() but snd_soc_update_bits() ?
> Ideally you should be using the framework features.  If there is some
> reason why you can't you need to make it much clearer what the reason
> is so people reading the code can understand.

If possible, I want to use framework features. However, I judged it is
not possible.
Let me confirm again.
As I said before, all ML26124 registers need to be accessed by
different address when read and write.
Like below
R       W
$00h $01h Sampling setting
$02h $03h PLL setting
...

Even so, can I use framework features ?

thanks,
-- 
ROHM Co., Ltd.
tomoya
