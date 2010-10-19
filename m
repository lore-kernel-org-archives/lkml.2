Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0JSSnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:43:10 -0400
Received: from fifo99.com ([67.223.236.141]:34087 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab0JSSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:43:08 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@fifo99.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <alpine.LFD.2.00.1010191314020.2764@xanadu.home>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <alpine.LFD.2.00.1010181833440.2764@xanadu.home>
	 <1287442418.5376.38.camel@Joe-Laptop> <201010191518.04147.arnd@arndb.de>
	 <1287507806.10071.16.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010191314020.2764@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 11:42:37 -0700
Message-ID: <1287513757.10071.45.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That's why on occasions we do transgress the established process to 
> accommodate such changes.  Imagine just for a moment the patch that 
> modified the interrupt callback prototype to remove the useless pt_regs 
> argument.  Obviously, it had to be done atomically to the _whole_ tree, 
> and it was agreed that this patch was to be applied at the end of the 
> merge window.  But no one expected a single minute sending a CC to _all_ 
> the driver authors.

I don't actually know which patch your talking about, but it sounds
pretty simple.. I'm not really addressing really simple fixes, even tho
changing a single parameter on a function could be done broken up
depending on what it is.

Daniel

