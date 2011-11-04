Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1KDPnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:43:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49035 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab1KDPnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:43:52 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 1/2] mfd: TPS65910: Improvements
Thread-Topic: [PATCH 1/2] mfd: TPS65910: Improvements
Thread-Index: AQHMmvAPfIftAWALckqyR6YHiImU9JWceYeAgABfsGA=
Date: Fri, 4 Nov 2011 15:43:40 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A90195CA@DBDE01.ent.ti.com>
References: <1320410912-20293-1-git-send-email-afzal@ti.com>
 <20111104152411.GB28615@opensource.wolfsonmicro.com>
In-Reply-To: <20111104152411.GB28615@opensource.wolfsonmicro.com>
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

Hi Mark,

On Fri, Nov 04, 2011 at 20:54:11, Mark Brown wrote:
> ...should be in two separate commits.

Ok

> 
> > 2. struct tps65910_platform_data usage can be avoided
> >  by making use of struct tps65910_board to simplify
> >  driver. Hence remove it
> 
> Why is this a simplification?  Note that one of the reasons platform
> data is kept separate from any runtime data the device needs is that it
> makes the configuration available easier to see and understand.
> 

Ok, I understand that this simplification should not be done.

Regards
Afzal
