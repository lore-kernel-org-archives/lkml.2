Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1KGWlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:41:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34736 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1KGWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:41:44 -0500
Date: Mon, 7 Nov 2011 22:41:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107224129.GJ15294@n2100.arm.linux.org.uk>
References: <1320688617-4543-1-git-send-email-balbi@ti.com> <20111107183208.GG15294@n2100.arm.linux.org.uk> <20111107193908.GA5059@legolas.emea.dhcp.ti.com> <20111107212707.GH15294@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1111071428001.12394@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111071428001.12394@utopia.booyaka.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:29:35PM -0700, Paul Walmsley wrote:
> On Mon, 7 Nov 2011, Russell King - ARM Linux wrote:
> 
> > Again, can never have been tested on OMAP3.
> > 
> > Does anyone apart from me bother doing any testing what so ever on OMAP3
> > platforms?  Am I the only one?
> 
> This was fixed by 
> 
> http://www.spinics.net/lists/arm-kernel/msg143549.html
> 
> which didn't go upstream as part of the v3.2 merge window.

Ah, that patch.

Which version of the patch does Tony have?  The one you point at which
uses IS_ERR_VALUE() and I complained about, or the version that has that
fixed?
