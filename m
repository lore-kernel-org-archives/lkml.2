Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab2J2QB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:01:29 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:43566 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759528Ab2J2QB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:01:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18HE8u/0hflwnSbJt7YDiDL
Date: Mon, 29 Oct 2012 09:01:23 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Constantine Shulyupin <const@MakeLinux.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, tim.bird@am.sony.com,
        pandaboard@googlegroups.com,
        Santosh Shilimkar OMAP <santosh.shilimkar@ti.com>, nsekhar@ti.com
Subject: Re: [PATCH] Add FDT support to Pandaboard initialization
Message-ID: <20121029160122.GB11908@atomide.com>
References: <1351363800-28744-1-git-send-email-const@MakeLinux.com>
 <20121029061427.GP17570@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029061427.GP17570@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [121028 23:22]:
> On Sat, Oct 27, 2012 at 08:50:00PM +0200, Constantine Shulyupin wrote:
> > From: Constantine Shulyupin <const@MakeLinux.com>
> > 
> > Problem:
> > - FDT is supported only by generic OMAP board initialization in arch/arm/mach-omap2/board-generic.c and lacks some configurations, which are not yet configured in FDT (USB for example).
> > Solution:
> > - arch/arm/mach-omap2/board-omap4panda.c supports initialization with FDT and without it.
> > 
> > Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> 
> NAK, the whole idea of DT is to drop board-*.c. It would be best to see
> the "missing initialization" being added to board-generic/dts files.

Yes I agree, let's rather get board-generic.c to work with panda.

The other board-*.c files will be dropped as soon as we have
things usable with devicetree. And we're only two board-*.c files
away from making omap4 device tree only ;)

I think we are only missing DSS, USB and WLAN bindings to
have blaze and panda usable with device tree to the point
where everything else can be added later on.

Regards,

Tony
