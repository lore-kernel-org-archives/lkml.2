Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1G2MUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:20:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40282 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab1G2MUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110728224357.GE829@flint.arm.linux.org.uk>
References: <1311740499.1536.56.camel@vkoul-udesk3>
	<CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
	<1311757347.1536.103.camel@vkoul-udesk3>
	<20110727095909.GB16623@intel.com>
	<CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com>
	<CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com>
	<CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com>
	<20110727202859.GA5028@flint.arm.linux.org.uk>
	<CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
	<CACRpkdbauudu_GXfsaB23sSepf=_rzt577Hb7pA9rRRrEFYj-w@mail.gmail.com>
	<20110728224357.GE829@flint.arm.linux.org.uk>
Date: Fri, 29 Jul 2011 14:20:00 +0200
X-Google-Sender-Auth: KohzGoefiCaOKcKd8SMXVycmj30
Message-ID: <CAKnu2Mq+M8fZDPyFxatw5UV2wfr5sKP2Za4pD0Trz=k1-WG3Mg@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Russell King <rmk@arm.linux.org.uk>:
> On Fri, Jul 29, 2011 at 12:27:58AM +0200, Linus Walleij wrote:
>> +static struct pl08x_channel_data ab926ejs_chan_data[] = {
>> +     [0] = {
>> +             .bus_id = "aacirx",
>> +             .min_signal = 0,
>> +             .max_signal = 0,
>> +             .cctl = PRIMECELL_DEFAULT_CCTL,
>> +             .ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,
>
> Linus,
>
> We really should sync our two implementations for this - all the ccfg
> stuff should be gone from these structures, esp. as its already long
> gone from the structure itself.

Sure, it was merely an illustration. I figured you must have some code
since you've been testing it on AACI and whatnot. I'm currently in the
countryside, I plan to pick this up when I get back to the office (where
the PB11MPCore is) in mid-august.

If you have some platform data + mux code that fits with your latest
patches to the PL08x driver, then please poste to LAKML and I'll have
them tested ASAP.

Yours,
Linus Walleij
