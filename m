Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2EIAjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 20:39:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46724 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2EIAjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 20:39:40 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Hilman, Kevin" <khilman@ti.com>
CC: "AnilKumar, Chimata" <anilkumar@ti.com>, "J, KEERTHY" <j-keerthy@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [linux-pm] [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage
 Scaling)
Thread-Topic: [linux-pm] [PATCH V3 00/10] PM: Create the AVS(Adaptive
 Voltage Scaling)
Thread-Index: AQHNLWg0bj9HGojxtk+Dc2CuogoNZ5bAmZ1w
Date: Wed, 9 May 2012 00:39:31 +0000
Message-ID: <EF62F09C0797D947AD4180A1043C0DF73C40C247@DLEE10.ent.ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com>	<87397o3n4y.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com>
	<87mx5jy2li.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B6681@DBDE01.ent.ti.com>
	<EF62F09C0797D947AD4180A1043C0DF73C40BCE1@DLEE10.ent.ti.com>
 <87lil2jp2z.fsf@ti.com>
In-Reply-To: <87lil2jp2z.fsf@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Hilman, Kevin
> Sent: Tuesday, May 08, 2012 5:17 PM

> A basic OMAP AVS driver has been in mainline for a long time, yet we
> have not seen support submitted for all of these features.

1.5/3.5 is a feature.

ABB is requirement for a production useable driver. Higher speed rated OMAP4 and all OMAP5 added these to be useable. Yes this is effort. Point of mentioning is to raise awareness of need.

Yet to be added feature has different meaning than functional gap.

Regards,
Richard W.

