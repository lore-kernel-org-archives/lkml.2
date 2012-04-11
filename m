Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2DKFP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:15:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36280 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab2DKFPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:15:25 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Hunter, Jon" <jon-hunter@ti.com>
CC: "tony@atomide.com" <tony@atomide.com>, "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grinberg@compulab.co.il" <grinberg@compulab.co.il>,
        "mike@compulab.co.il" <mike@compulab.co.il>,
        "Menon, Nishanth" <nm@ti.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "vimal.newwork@gmail.com" <vimal.newwork@gmail.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 4/9] ARM: OMAP2+: gpmc-nand: populate gpmc configs
Thread-Topic: [PATCH v3 4/9] ARM: OMAP2+: gpmc-nand: populate gpmc configs
Thread-Index: AQHNE0RieC4remNYK0+7wFXWxVKt5JaUHH8AgAEAVqA=
Date: Wed, 11 Apr 2012 05:15:12 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9317C6F64@DBDE01.ent.ti.com>
References: <cover.1333640054.git.afzal@ti.com>
 <6c120ab77d0900a6f977246bc58fb37c62280371.1333640054.git.afzal@ti.com>
 <4F84890A.30500@ti.com>
In-Reply-To: <4F84890A.30500@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Wed, Apr 11, 2012 at 00:54:58, Hunter, Jon wrote:
> > +#define	GPMC_NAND_CONFIG_NUM	4
> 
> Where does 4 come from?


It depends on the use case, for NAND, with the way it was being
configured (or number of times gpmc_cs_configure was being called)
4 are needed.

Regards
Afzal
