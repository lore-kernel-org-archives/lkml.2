Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1KDO0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:26:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59968 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550Ab1KDO0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:26:18 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: RE: [PATCH 2/2] regulator:TPS65910: VDD1/2 voltage selector count
Thread-Topic: [PATCH 2/2] regulator:TPS65910: VDD1/2 voltage selector count
Thread-Index: AQHMmvAZ0k5z8ytqW0i9aFLP+z33G5WcYzoAgABeBtA=
Date: Fri, 4 Nov 2011 14:26:05 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A90194B0@DBDE01.ent.ti.com>
References: <1320410928-20349-1-git-send-email-afzal@ti.com>
 <20111104140422.GA28615@opensource.wolfsonmicro.com>
In-Reply-To: <20111104140422.GA28615@opensource.wolfsonmicro.com>
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

Hi Brown,

On Fri, Nov 04, 2011 at 19:34:22, Mark Brown wrote:
> On Fri, Nov 04, 2011 at 06:18:48PM +0530, Afzal Mohammed wrote:
> 
> >  		if (i == TPS65910_REG_VDD1 || i == TPS65910_REG_VDD2) {
> >  			pmic->desc[i].ops = &tps65910_ops_dcdc;
> > +			pmic->desc[i].n_voltages = VDD1_2_NUM_VOLTS * 3;
> 
> This looks suspicous - what's the * 3 about?
> 

Gain in voltage possible is x1, 0x2 & 0x3, I am shaky
about this change, but voltage could be changed with this,
cc'ing original author's

Specification @ http://www.ti.com/product/tps65910

Regards
Afzal
