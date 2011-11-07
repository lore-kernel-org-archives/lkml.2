Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1KGWzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:55:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56948 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1KGWzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:55:44 -0500
Date: Mon, 7 Nov 2011 22:55:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107225529.GK15294@n2100.arm.linux.org.uk>
References: <1320688617-4543-1-git-send-email-balbi@ti.com> <20111107183208.GG15294@n2100.arm.linux.org.uk> <20111107193908.GA5059@legolas.emea.dhcp.ti.com> <20111107212707.GH15294@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1111071428001.12394@utopia.booyaka.com> <20111107224129.GJ15294@n2100.arm.linux.org.uk> <20111107225157.GB31337@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107225157.GB31337@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:51:57PM -0800, Tony Lindgren wrote:
> Here's what I got. Looks like the removal of the sr[12]_hwmod
> part is no longer needed, so only the r value check part is needed.

Err.  So do you have anything in your git tree which you're pushing out
this evening which removes the sr[12]_hwmod from the omap_3xxx_hwmod
list?

If not, how does that bug get fixed in mainline?
