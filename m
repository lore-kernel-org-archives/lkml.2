Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2DRKU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:20:56 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:1730 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224Ab2DRKUy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:20:54 -0400
X-SpamScore: -8
X-BigFish: VS-8(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hbe9i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Li Yang-R58472 <r58472@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
        Zhao Chenhui-B35336 <B35336@freescale.com>
CC: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Thread-Topic: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Thread-Index: AQHM9s45UHTdeG+owEuJafi37ouDH5ZUm4+AgEsVTICAAPd+UA==
Date: Wed, 18 Apr 2012 10:20:36 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F092D1DC7@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
 <20120229183436.GA30545@pengutronix.de>
 <20120417142105.GA21802@pengutronix.de>
In-Reply-To: <20120417142105.GA21802@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Feb 29, 2012 at 07:45:23PM +0100, Wolfram Sang wrote:
> > Hi,
> >
> > On Wed, Feb 29, 2012 at 06:39:21PM +0800, Zhao Chenhui wrote:
> > > When entering deep sleep, the value in the registers I2CFDR and
> > > I2CDFSRR are lost. This causes I2C access to fail after resuming.
> > >
> > > Add suspend/resume routines to save/restore the registers I2CFDR and
> > > I2CDFSRR.
> > >
> > > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > > Signed-off-by: Li Yang <leoli@freescale.com>
> > > ---
> > >  drivers/i2c/busses/i2c-mpc.c |   34
> +++++++++++++++++++++++++++++++++-
> > >  1 files changed, 33 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/i2c/busses/i2c-mpc.c
> > > b/drivers/i2c/busses/i2c-mpc.c index a8ebb84..f95a647 100644
> > > --- a/drivers/i2c/busses/i2c-mpc.c
> > > +++ b/drivers/i2c/busses/i2c-mpc.c
> > > @@ -1,7 +1,9 @@
> > >  /*
> > >   * (C) Copyright 2003-2004
> > >   * Humboldt Solutions Ltd, adrian@humboldt.co.uk.
> > > -
> > > + *
> > > + * Copyright 2012 Freescale Semiconductor, Inc.
> > > + *
> >
> > I'd think the change is too trivial to claim copyright on the file.
> 
> Do you want to resend with the comments addressed?

We have a company policy for adding copyright claims.  And this patch has met our criteria that requires adding copyright.

We certainly don't want the policy to be against the common practice of the community.  If it is we can consider changing our policy.  However I can't find a clear message stating the consensus of what the Linux kernel community think of adding copyright claims.  I even found some message that encourage adding copyright to maintain the GPL license.

- Leo

