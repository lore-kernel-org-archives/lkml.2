Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1KDQkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 12:40:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35690 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755925Ab1KDQkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 12:40:12 -0400
Date: Fri, 4 Nov 2011 16:40:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator:TPS65910: VDD1/2 voltage selector count
Message-ID: <20111104164009.GA753@opensource.wolfsonmicro.com>
References: <1320410928-20349-1-git-send-email-afzal@ti.com>
 <20111104140422.GA28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A90194B0@DBDE01.ent.ti.com>
 <20111104152559.GC28615@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019607@DBDE01.ent.ti.com>
 <20111104161855.GC28902@opensource.wolfsonmicro.com>
 <C8443D0743D26F4388EA172BF4E2A7A9019650@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A9019650@DBDE01.ent.ti.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 04:32:43PM +0000, Mohammed, Afzal wrote:
> On Fri, Nov 04, 2011 at 21:48:56, Mark Brown wrote:
> > So that definitely seems wrong then - n_voltages is supposed to be the
> > number of voltages that can be selected so if the regulator supports
> > _NUM_VOLTS steps then I'd expect to see that constant used directly.
> > Otherwise I'd suggest that the magic number needs a #define.

> A gain of 0x1, 0x2, 0x3 is possible for each of the voltage steps,
> so we have a total of _NUM_VOLTS * 3 steps (although some of them
> would be same values).

What do you mean when you say "gain"?
