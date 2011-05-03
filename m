Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1ECKoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:44:10 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44865 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752038Ab1ECKoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:44:08 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+EbKMbik+YA0btnntSmBdG
Date: Tue, 3 May 2011 03:44:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/8] arm/dt: probe for platforms via the device tree
Message-ID: <20110503104401.GQ2092@atomide.com>
References: <20110429070135.12522.35745.stgit@ponder>
 <20110429071548.12522.56929.stgit@ponder>
 <20110502151542.GG2092@atomide.com>
 <BANLkTikue6jMUcQMv9GD4cZ=o5EEW7QDqQ@mail.gmail.com>
 <20110502163951.GC9243@atomide.com>
 <20110502215537.GE10097@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502215537.GE10097@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [110502 14:52]:
> On Mon, May 02, 2011 at 07:39:54PM +0300, Tony Lindgren wrote:
> > 
> > The cmdline is something that bootloaders typically allow to configure,
> > while the other ATAGs are static and should be in the .dts file.
> 
> Once the libfdt code is pulled into to manipulate the command line,
> it becomes trivial to parse the rest of the atags too, so this
> probably won't make much difference (unless work is done to preparse
> the devicetree and provide to the zimage wrapper a direct offset to
> the cmdline buffer in the dtb, but that gets hairy and I really don't
> want to go down that path).
 
OK, makes sense.
  
> > > Adding a default command line to the .dts file instead of using
> > > CONFIG_CMDLINE_FORCE also works.
> > 
> > But that requires carrying extra patches for something that should
> > be user configured.. So not so nice for distros.
> 
> Right, so this is only a stop-gap solution.  I'll add this to the list
> of topics to discuss in the device tree session at Linaro@UDS next
> week.

Thanks

Tony
