Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab2CPEHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:07:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36546 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2CPEHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:07:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120315105048.GF3138@opensource.wolfsonmicro.com>
References: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
	<1331275091-31700-1-git-send-email-tomoya.rohm@gmail.com>
	<20120314144524.GT3133@opensource.wolfsonmicro.com>
	<CANKRQni-8w+2p6=ZisQ+GXhGpNmYhesKfTHfOjWGGrQrhvTFGA@mail.gmail.com>
	<20120315105048.GF3138@opensource.wolfsonmicro.com>
Date: Fri, 16 Mar 2012 13:07:03 +0900
Message-ID: <CANKRQnhg21hjKjSOtDwbfK9shNsdcEu-aiSs1zVGNtAdaHdMHw@mail.gmail.com>
Subject: Re: [PATCH v6] sound/soc/lapis: add machine driver for ML7213 Carrier Board
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

On Thu, Mar 15, 2012 at 7:50 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Mar 15, 2012 at 01:50:48PM +0900, Tomoya MORINAGA wrote:
>
>> OK.
>> codec is slave, i2s controller is master.
>> So, I'll use SND_SOC_DAIFMT_CBS_CFM.
>
> That means "Codec bit clock master frame clock slave".  Are you sure
> that's what you want?

Let me clarify the above.
Does the above "frame clock" mean "data line" of I2S?
If yes, I should have used 'SND_SOC_DAIFMT_CBS_CFS'.

thanks.
-- 
ROHM Co., Ltd.
tomoya
