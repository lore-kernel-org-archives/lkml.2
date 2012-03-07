Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2CGPrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:47:04 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:36038 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759409Ab2CGPrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:47:02 -0500
Date: Wed, 7 Mar 2012 16:36:22 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Nancy Chen <Nancy.Chen@freescale.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v9] Regulator: Add Anatop regulator driver
Message-ID: <20120307153622.GC17745@game.jcrosoft.org>
References: <1331126658-26926-1-git-send-email-paul.liu@linaro.org>
 <20120307132225.GB17745@game.jcrosoft.org>
 <20120307134551.GL3107@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307134551.GL3107@opensource.wolfsonmicro.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9435604170485639983
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:45 Wed 07 Mar     , Mark Brown wrote:
> On Wed, Mar 07, 2012 at 02:22:25PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > > +- compatible: Must be "fsl,anatop-regulator"
> > > +- vol-bit-shift: Bit shift for the register
> > > +- vol-bit-width: Number of bits used in the register
> > > +- min-bit-val: Minimum value of this register
> > > +- min-voltage: Minimum voltage of this regulator
> > > +- max-voltage: Maximum voltage of this regulator
> 
> > specific properites need to be prefix by the vendor
> 
> This really doesn't seem at all sane for a device which is already
> vendor specific, it's just noise in the bindings.
No it's
Here is a good example as we have regulator generic binding & vendor
specific bindig

Best Regards,
J.
