Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2CHCYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:24:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38852 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2CHCYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:24:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120307114811.GF3107@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<20120229235147.GM8295@opensource.wolfsonmicro.com>
	<CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
	<20120302125819.GE3230@opensource.wolfsonmicro.com>
	<CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
	<20120306100012.GC19635@opensource.wolfsonmicro.com>
	<CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
	<20120306121222.GK19635@opensource.wolfsonmicro.com>
	<CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
	<20120307114811.GF3107@opensource.wolfsonmicro.com>
Date: Thu, 8 Mar 2012 11:24:36 +0900
Message-ID: <CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
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

On Wed, Mar 7, 2012 at 8:48 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> If possible, I want to use framework features. However, I judged it is
>> not possible.
>> Let me confirm again.
>> As I said before, all ML26124 registers need to be accessed by
>> different address when read and write.
>> Like below
>> R       W
>> $00h $01h Sampling setting
>> $02h $03h PLL setting
>> ...
>> Even so, can I use framework features ?
> No, in which case (to repeat what I said previously) you need to make
> the code *much* clearer so the reader can understand what it is doing
> and why it's having to open code this stuff.

I understand you agree to use ml26124_update_bits(), right ?
If so, do you mean that I should just add explanation (like as I
explained before)
why the function() is necessary to above prototype of ml26124_update_bits() ?

thanks.
-- 
ROHM Co., Ltd.
tomoya
