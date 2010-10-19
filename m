Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0JSSxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:53:48 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49443 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab0JSSxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:53:47 -0400
Date: Tue, 19 Oct 2010 19:53:13 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Arnd Bergmann <arnd@arndb.de>,
        Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20101019185313.GB11088@flint.arm.linux.org.uk>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au> <alpine.LFD.2.00.1010181833440.2764@xanadu.home> <1287442418.5376.38.camel@Joe-Laptop> <201010191518.04147.arnd@arndb.de> <1287507806.10071.16.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1010191314020.2764@xanadu.home> <1287513757.10071.45.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287513757.10071.45.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:42:37AM -0700, Daniel Walker wrote:
> 
> > That's why on occasions we do transgress the established process to 
> > accommodate such changes.  Imagine just for a moment the patch that 
> > modified the interrupt callback prototype to remove the useless pt_regs 
> > argument.  Obviously, it had to be done atomically to the _whole_ tree, 
> > and it was agreed that this patch was to be applied at the end of the 
> > merge window.  But no one expected a single minute sending a CC to _all_ 
> > the driver authors.
> 
> I don't actually know which patch your talking about, but it sounds
> pretty simple.. I'm not really addressing really simple fixes, even tho
> changing a single parameter on a function could be done broken up
> depending on what it is.

As you think that it's a simple matter, I challenge you to break this
change up in a way that doesn't result in any build breakage:
	7d12e780e003f93433d49ce78cfedf4b4c52adc5

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
