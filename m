Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1KDQs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:48:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42286 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1KDQsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:48:24 -0400
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
Thread-Index: AQHMmvAZ0k5z8ytqW0i9aFLP+z33G5WcYzoAgABeBtD//7jHgIAAYTBw//+tnACAAFyJoP//qWSAAAuXTzA=
Date: Fri, 4 Nov 2011 16:48:09 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9019691@DBDE01.ent.ti.com>
References: <1320410928-20349-1-git-send-email-afzal@ti.com>
 <20111104140422.GA28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A90194B0@DBDE01.ent.ti.com>
 <20111104152559.GC28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019607@DBDE01.ent.ti.com>
 <20111104161855.GC28902@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019650@DBDE01.ent.ti.com>
 <20111104164009.GA753@opensource.wolfsonmicro.com>
In-Reply-To: <20111104164009.GA753@opensource.wolfsonmicro.com>
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

On Fri, Nov 04, 2011 at 22:10:09, Mark Brown wrote:
> 
> What do you mean when you say "gain"?
> 

Effective voltage expression is (value1 * 12.5mV + 562.5 mV) * value2.

In this value2 is being called as gain.

value1 can have values from 3 to 75, both inclusive (73 steps)
value2 can have from 1 to 3, both inclusive (3 numbers)

Regards
Afzal
