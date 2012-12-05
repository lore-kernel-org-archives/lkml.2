Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2LEMfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:35:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56232 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2LEMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:35:03 -0500
Date: Wed, 5 Dec 2012 13:34:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Philip Balister <philip@balister.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>, dinguyen@altera.com
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121205123459.GB30445@amd.pavel.ucw.cz>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <20121130173644.GA9841@kroah.com>
 <50B97734.3090207@balister.org>
 <201212012048.51012.arnd@arndb.de>
 <50BE53E4.1040303@balister.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BE53E4.1040303@balister.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Agreed. If I understand you correctly though, your approach is specific
> >to a particular hardware implementation (Zynq) on the user interface layer,
> >which I think is exactly what we should avoid. Obviously, there is
> >always a driver involved that is specific to the IP block you load into
> >an FPGA at runtime, and that is ok. The two parts that I think we
> >should agree on are:

> The approach I am taking is not Zynq specific. The only Zynq
> specific bits will be range checking data from the device tree to
> make sure the user is mapping address space that is used by the FPGA
> and a similar validation of the IRQ numbers. I have not looked at
> the Altera part closely, but I suspect their fpga/processor
> interface may use similar concepts.

So... the arch may be called socfpga, but I don't think we managed to
merge actual fpga parts, yet ;-). In fact, I'm not sure if I actually
seen those... Dinh should know more about status there.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
