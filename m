Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab2GMFnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:43:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39296 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915Ab2GMFnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:43:45 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: RE: [PATCH v2 1/3] regulator: tps65217: Add device tree support
Thread-Topic: [PATCH v2 1/3] regulator: tps65217: Add device tree support
Thread-Index: AQHNXoyJ1e7o53AxukKdiqQa3gtClJcljj2AgAEo2TA=
Date: Fri, 13 Jul 2012 05:43:30 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9F61CC@DBDE01.ent.ti.com>
References: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
 <1341918584-28004-2-git-send-email-anilkumar@ti.com>
 <20120712172836.GR7256@opensource.wolfsonmicro.com>
In-Reply-To: <20120712172836.GR7256@opensource.wolfsonmicro.com>
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

Hi Mark,

On Thu, Jul 12, 2012 at 22:58:37, Mark Brown wrote:
> On Tue, Jul 10, 2012 at 04:39:42PM +0530, AnilKumar Ch wrote:
> > This commit adds device tree support for tps65217 pmic. And usage
> > details are added to device tree documentation. Driver is tested
> > by using kernel module with regulator set and get APIs.
> 
> Applied, thanks.

Thanks much, are you going to push reset of the patches in this series?

Thanks
AnilKumar
