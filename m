Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1EZPG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:06:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59693 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1EZPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:06:58 -0400
Date: Thu, 26 May 2011 09:06:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Xilinx: Adding zynq platform support
Message-ID: <20110526150655.GA26661@ponder.secretlab.ca>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com>
 <alpine.LFD.2.00.1105241435550.3207@xanadu.home>
 <BANLkTi=hCpCbNzi1ZiKmGnbhmCG2Ce=EkA@mail.gmail.com>
 <201105261559.41993.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105261559.41993.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 03:59:41PM +0200, Arnd Bergmann wrote:
> On Wednesday 25 May 2011, Grant Likely wrote:
> > 
> > As per discussion attached below.  Please pull this tree adding device
> > tree support to ARM, plus some other minor device tree changes.
> 
> Hi Grant and Linus,
> 
> There is also the new Xilinx zynq subarchitecture pending that depends
> on this, see below. Should we also include that right away, in order
> to have an example for other platforms? I think the code is clean
> enough and it would be good to have.
> 
> 	Arnd

Yes, this one definitely should (as we discussed in Budapest 2 weeks back).
Its been in linux-next for a while now too.

I've picked it up into devicetree/arm-next and run through a few build
tests before I push it out and update the pull request.

g.

