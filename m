Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1LFTpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:45:34 -0500
Received: from relais.videotron.ca ([24.201.245.36]:16171 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1LFTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:45:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 06 Dec 2011 14:45:30 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Tixy <tixy@yxit.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        John Holland <john.holland@cellent-fs.de>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH] ARM: kirkwood: Remove eSATA SheevaPlug board support
In-reply-to: <1323155228.2237.10.camel@computer2>
Message-id: <alpine.LFD.2.02.1112061442430.2357@xanadu.home>
References: <1322737480.9622.5.camel@phoenix>
 <1322912383.2378.79.camel@computer2>
 <alpine.LFD.2.02.1112031247230.2357@xanadu.home>
 <1323155228.2237.10.camel@computer2>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, Tixy wrote:

> On Sat, 2011-12-03 at 13:00 -0500, Nicolas Pitre wrote:
> > On Sat, 3 Dec 2011, Tixy wrote:
> > > [PATCH] Fix machine_is_xxx() naming for eSata SheevaPlug and QNAP TS-209
> > > 
> > > The eSata SheevaPlug and QNAP TS-209 devices were removed from
> > > mach-types due to naming mismatches between machine_is_xxx(), CONFIG_XXX
> > > and MACH_TYPE_XXX.
> > > 
> > > This patch fixes those mismatches and adds the devices back into
> > > mach-types.
> > > 
> > > Cc: Nicolas Pitre <nico@fluxnic.net>
> > > Cc: Lennert Buytenhek <kernel@wantstofly.org>
> > > Cc: Russell King <linux@arm.linux.org.uk>
> > > Signed-off-by: Jon Medhurst <tixy@yxit.co.uk>
> > 
> > Acked-by: Nicolas Pitre <nico@linaro.org>
> > 
> > Obviously, the change to mach-types should be done in the machine 
> > registry database as well by RMK.
> 
> Which tree should this go through? Russell's or arm-soc?

The arm-soc tree is probably more appropriate.  Don't include the 
mach-types changes though as it is preferable if they come through RMK's 
database updates.


Nicolas
