Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1G1WoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:44:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50272 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab1G1WoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:44:15 -0400
Date: Thu, 28 Jul 2011 23:43:57 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Message-ID: <20110728224357.GE829@flint.arm.linux.org.uk>
References: <1311740499.1536.56.camel@vkoul-udesk3> <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com> <1311757347.1536.103.camel@vkoul-udesk3> <20110727095909.GB16623@intel.com> <CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com> <CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com> <CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com> <20110727202859.GA5028@flint.arm.linux.org.uk> <CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com> <CACRpkdbauudu_GXfsaB23sSepf=_rzt577Hb7pA9rRRrEFYj-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbauudu_GXfsaB23sSepf=_rzt577Hb7pA9rRRrEFYj-w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 12:27:58AM +0200, Linus Walleij wrote:
> +static struct pl08x_channel_data ab926ejs_chan_data[] = {
> +	[0] = {
> +		.bus_id = "aacirx",
> +		.min_signal = 0,
> +		.max_signal = 0,
> +		.cctl = PRIMECELL_DEFAULT_CCTL,
> +		.ccfg = PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT,

Linus,

We really should sync our two implementations for this - all the ccfg
stuff should be gone from these structures, esp. as its already long
gone from the structure itself.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
