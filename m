Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2GPMgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:36:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43683 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2GPMf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:35:59 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH v2 1/3] regulator: tps65217: Add device tree support
Thread-Topic: [PATCH v2 1/3] regulator: tps65217: Add device tree support
Thread-Index: AQHNXoyJ1e7o53AxukKdiqQa3gtClJcljj2AgAEo2TD//+q4AIAFMjBA
Date: Mon, 16 Jul 2012 12:35:46 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9F70AE@DBDE01.ent.ti.com>
References: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
 <1341918584-28004-2-git-send-email-anilkumar@ti.com>
 <20120712172836.GR7256@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9F61CC@DBDE01.ent.ti.com>
 <20120713095454.GB4215@opensource.wolfsonmicro.com>
In-Reply-To: <20120713095454.GB4215@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Tony

Tony,

On Fri, Jul 13, 2012 at 15:24:54, Mark Brown wrote:
> On Fri, Jul 13, 2012 at 05:43:30AM +0000, AnilKumar, Chimata wrote:
> 
> > Thanks much, are you going to push reset of the patches in this series?
> 
> No, there's no dependency so I'd expect them to be applied by the
> architecture maintainers.
> 

Could you please push these [2/3 and 3/3] patches to linux-omap "devel-dt
tree"?
http://marc.info/?l=linux-omap&m=134191889501150&w=2
http://marc.info/?l=linux-omap&m=134191891701159&w=2

After these patches, "PMIC I2C slave address addition for AM335x EVM/Bone
will be submitted, which actually passes DT data to tps65910/217 drivers"

Regards
AnilKumar