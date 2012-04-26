Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2DZFWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:22:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51662 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2DZFWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:22:05 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Hilman, Kevin" <khilman@ti.com>,
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
Subject: RE: [TMP] OMAP3EVM: Test gpmc nand & smsc911x
Thread-Topic: [TMP] OMAP3EVM: Test gpmc nand & smsc911x
Thread-Index: AQHNIwMdEGX/RUlvsUOdhHBXeMoC65ashtrw
Date: Thu, 26 Apr 2012 05:21:45 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E970122@DBDE01.ent.ti.com>
References: <cover.1333640054.git.afzal@ti.com>
 <bb95fec60401f7cf6ac77200a12baf3fc83852f5.1333640054.git.afzal@ti.com>
 <20120425164726.GU3739@atomide.com>
In-Reply-To: <20120425164726.GU3739@atomide.com>
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

Hi Tony,

On Wed, Apr 25, 2012 at 22:17:26, Tony Lindgren wrote:
> Obviously we can't merge any of this if until all the board-*.c files
> are changed and tested.
> 
> Can you maybe still keep the old interfaces in addition to the new ones
> so we can do the conversion one board-*.c file at a time while keeping
> things working?

As there are peripherals using helper functions, to handle those, you
meant to create a new altered similar function to deal for each too ?,
while keeping existing functions as such.

i.e. like having gpmc_smsc911x_init & gpmc_smsc911x_new_init for
each peripheral ?, with gpmc_smsc911x_new_init using gpmc driver,
and gpmc_smsc911x_init as is.

Regards
Afzal


