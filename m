Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2HJHXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 03:23:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36455 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279Ab2HJHXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 03:23:44 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] mfd: add lp8788 mfd driver
Thread-Topic: [PATCH v2 1/3] mfd: add lp8788 mfd driver
Thread-Index: Ac12CB1InAlCHqp1Tw2q0ybDE4xof///wPIA//5DNxA=
Date: Fri, 10 Aug 2012 07:23:36 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEF214@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EEBC45@DBDE02.ent.ti.com>
 <20120809100648.GF24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120809100648.GF24328@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Patch v2.
> > (a) For interrupt handling, use generic irq rather than irq-domain
> 
> This seems like a very substantial step backwards, why make this change?
> Using irqdomain solves a bunch of problems, especially around virq
> allocation, and is where we want all drivers to go longer term.

Yes, you're right.
I moved it to old concept because I have to figure out the irq domain,
especially device tree interface.
I'm still not clear.

For the phased development, my plan is 
1) submitting lp8788 driver with generic irq
2) patch for supporting irq domain later

Best Regards,
Milo




