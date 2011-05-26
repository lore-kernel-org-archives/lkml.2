Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab1EZWBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:01:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35713 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576Ab1EZWBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:01:47 -0400
Date: Thu, 26 May 2011 23:01:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Xilinx: Adding zynq platform support
Message-ID: <20110526220120.GN24876@n2100.arm.linux.org.uk>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com> <alpine.LFD.2.00.1105241435550.3207@xanadu.home> <BANLkTi=hCpCbNzi1ZiKmGnbhmCG2Ce=EkA@mail.gmail.com> <201105261559.41993.arnd@arndb.de> <20110526150655.GA26661@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526150655.GA26661@ponder.secretlab.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 09:06:55AM -0600, Grant Likely wrote:
> On Thu, May 26, 2011 at 03:59:41PM +0200, Arnd Bergmann wrote:
> > On Wednesday 25 May 2011, Grant Likely wrote:
> > > 
> > > As per discussion attached below.  Please pull this tree adding device
> > > tree support to ARM, plus some other minor device tree changes.
> > 
> > Hi Grant and Linus,
> > 
> > There is also the new Xilinx zynq subarchitecture pending that depends
> > on this, see below. Should we also include that right away, in order
> > to have an example for other platforms? I think the code is clean
> > enough and it would be good to have.
> > 
> > 	Arnd
> 
> Yes, this one definitely should (as we discussed in Budapest 2 weeks back).
> Its been in linux-next for a while now too.
> 
> I've picked it up into devicetree/arm-next and run through a few build
> tests before I push it out and update the pull request.

Note that I've pulled the dt stuff into my tree a few days ago already.
