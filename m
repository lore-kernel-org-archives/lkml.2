Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1G0Kf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:35:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:60450 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab1G0Kfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:35:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="32559264"
Date: Wed, 27 Jul 2011 13:36:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linus.walleij@stericsson.com,
        per.friden@stericsson.com, wei.zhang@freescale.com,
        ebony.zhu@freescale.com, iws@ovro.caltech.edu, s.hauer@pengutronix.de,
        maciej.sosnowski@intel.com, saeed@marvell.com, shawn.guo@freescale.com,
        yur@emcraft.com, agust@denx.de, iwamatsu.nobuhiro@renesas.com,
        per.forlin@stericsson.com, jonas.aberg@stericsson.com,
        anemo@mba.ocn.ne.jp
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Message-ID: <20110727103609.GC16623@intel.com>
References: <CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
 <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
 <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
 <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
 <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
 <1311740499.1536.56.camel@vkoul-udesk3>
 <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com>
 <1311757347.1536.103.camel@vkoul-udesk3>
 <20110727095909.GB16623@intel.com>
 <1311759264.1536.113.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311759264.1536.113.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 03:04:24PM +0530, Koul, Vinod wrote:

> Is this a dma controller limitation or due to the fact even channels get
> assigned h/w interface corresponding to TX and so on.

I think the later but not sure how it is implemented in hw. The
documentation only states that even channels are for TX and odd for RX.
There is no way of changing the direction as far I can tell.
