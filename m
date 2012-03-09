Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2CIOPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:15:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2CIOPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:15:39 -0500
Date: Fri, 9 Mar 2012 15:15:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <20120309140705.GV17370@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1203091514080.7852@axis700.grange>
References: <Pine.LNX.4.64.1203080902170.29847@axis700.grange>
 <1331204128.4657.54.camel@vkoul-udesk3> <Pine.LNX.4.64.1203081200170.29847@axis700.grange>
 <1331206459.4657.59.camel@vkoul-udesk3> <1331211513.4657.67.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203081412550.29847@axis700.grange> <1331284918.4657.69.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203091022200.7852@axis700.grange> <1331285959.4657.76.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1203091049060.7852@axis700.grange> <20120309140705.GV17370@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:TceF9uesfb8swZkcrVN4u8AYpYzS2LjqGOfuEaC6Fs0
 CVRhl6fPbaYQFFp2V3o17OIEUYGQAcoOlVi6qrnWS4RqVik0DA
 SDq1k5BlaUxY3PGrFptAgMvWM+A+wMrGofEYgUWHQDk1TSJVh3
 ixzzkYfaOEQxU+Sq0YErj9HEAlzrTXSwHyr/dAvhOPHfzjxxUX
 BMdz/Nd9utk2t0yJq62SGxsPoetRNBIQ/qNACmUGL5Kyk3zvEB
 xj67YKFbn8JDRaCKTikmUeY2MIzD/WQBXoUbR4FjJKQG8/Uqh5
 /Lbb8bJXBx2IbvDR7uYhNB+yAuXVzUKByfexXXZ14lAqojc47t
 x3ScocPGCGtAb6On1IYvCq2eRWjpYBcWOJVpkLVLWiNhNQDUWd
 s1kuQ+znbOG1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Russell King - ARM Linux wrote:

> On Fri, Mar 09, 2012 at 01:20:08PM +0100, Guennadi Liakhovetski wrote:
> > As Russell mentioned, struct dma_slave_config isn't suitable for channel 
> > configuration.
> 
> Actually, I said the exact reverse of what you've just stated.
> 
> I also stated (on more than one occasion) that dma_slave_config contains
> nothing relevant to channel selection.

Oops, ok, sorry, should have re-read. In any case, it is not suitable to 
configure sh-mobile DMAC channels.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
