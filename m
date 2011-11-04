Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1KDQc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:32:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39316 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab1KDQcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:32:55 -0400
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
Thread-Index: AQHMmvAZ0k5z8ytqW0i9aFLP+z33G5WcYzoAgABeBtD//7jHgIAAYTBw//+tnACAAFyJoA==
Date: Fri, 4 Nov 2011 16:32:43 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9019650@DBDE01.ent.ti.com>
References: <1320410928-20349-1-git-send-email-afzal@ti.com>
 <20111104140422.GA28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A90194B0@DBDE01.ent.ti.com>
 <20111104152559.GC28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019607@DBDE01.ent.ti.com>
 <20111104161855.GC28902@opensource.wolfsonmicro.com>
In-Reply-To: <20111104161855.GC28902@opensource.wolfsonmicro.com>
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

On Fri, Nov 04, 2011 at 21:48:56, Mark Brown wrote:
> So that definitely seems wrong then - n_voltages is supposed to be the
> number of voltages that can be selected so if the regulator supports
> _NUM_VOLTS steps then I'd expect to see that constant used directly.
> Otherwise I'd suggest that the magic number needs a #define.
> 

A gain of 0x1, 0x2, 0x3 is possible for each of the voltage steps,
so we have a total of _NUM_VOLTS * 3 steps (although some of them
would be same values).

Let me know your opinion on using _NUM_VOLTS * NUM_GAIN instead,
with #define NUM_GAIN 3.

Regards
Afzal
