Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031047Ab2CGB5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:57:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40381 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab2CGB5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <20120306115407.GE19635@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
	<1329976011-2251-3-git-send-email-tomoya.rohm@gmail.com>
	<20120302130509.GF3230@opensource.wolfsonmicro.com>
	<CANKRQnhHo1P0cmxyfUAShTinWMv0B81d8v8f7M6Oj3Yx9807zg@mail.gmail.com>
	<20120306115407.GE19635@opensource.wolfsonmicro.com>
Date: Wed, 7 Mar 2012 10:57:07 +0900
Message-ID: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
Subject: Re: [PATCH v5] sound/soc/lapis: add machine driver for ML7213 Carrier Board
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 8:54 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > You're also missing a blank line between this and the previous stanza.
>> Sorry, I can't understand your saying.
> Your file should look like other similar files in the kernel.

Aha, I could understand.
Need to add blank line before "config SND_SOC_ML7213_MACHINE" line.

thanks.
-- 
ROHM Co., Ltd.
tomoya
