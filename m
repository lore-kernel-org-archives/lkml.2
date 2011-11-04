Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1KDQBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:01:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39751 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1KDQBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:01:15 -0400
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
Thread-Index: AQHMmvAZ0k5z8ytqW0i9aFLP+z33G5WcYzoAgABeBtD//7jHgIAAYTBw
Date: Fri, 4 Nov 2011 16:01:04 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9019607@DBDE01.ent.ti.com>
References: <1320410928-20349-1-git-send-email-afzal@ti.com>
 <20111104140422.GA28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A90194B0@DBDE01.ent.ti.com>
 <20111104152559.GC28615@opensource.wolfsonmicro.com>
In-Reply-To: <20111104152559.GC28615@opensource.wolfsonmicro.com>
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

On Fri, Nov 04, 2011 at 20:55:59, Mark Brown wrote:
> On Fri, Nov 04, 2011 at 02:26:05PM +0000, Mohammed, Afzal wrote:
> > Hi Brown,
> 
> Ahem.

I am sorry for that if it offended you, not deliberate, this may
have to do with our different cultures, for me it is always a
confusion whether I should call a person with their first or
second name (unless he writes it at the end of mail). Normally my
name is written "Mohammed Afzal", but I am called "Afzal".


> 
> > On Fri, Nov 04, 2011 at 19:34:22, Mark Brown wrote:
> That doesn't really clarify things - the question is why the number of
> voltages we can set is three times a constant called _NUM_VOLTS?
> 

_NUM_VOLTS is the number of voltage steps.

I will try to come up with a better explanation or rather the
right solution, new to regulator world as of now.

Regards
Afzal
