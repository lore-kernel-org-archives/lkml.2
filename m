Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab1JCS3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:29:50 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59487 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932264Ab1JCS3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:29:45 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+fwhl1nEDTAEOYjDgzZxeH
Date: Mon, 3 Oct 2011 11:29:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] ARM/omap: omap specific randconfig fixes
Message-ID: <20111003182941.GG6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <4E894295.5000608@ti.com>
 <7246478.IyGHQ24uSq@wuerfel>
 <4E898388.40601@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E898388.40601@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [111003 02:08]:
> On Monday 03 October 2011 02:52 PM, Arnd Bergmann wrote:
> 
> > The main problem is that you basically need all the patches I did in order
> > to find regressions, and some of the device driver patches are not currently
> > in a state where I could submit them. I hope that by the time of the 3.3
> > merge window, I have enough patches upstream that you no longer need to
> > pull in an extra tree.
> > 
> Sounds like a plan and having these scripts working on mainline kernel
> would be really great to test new set dependencies.
> 
> Thanks a lot for the patches.

Thanks Arnd, this is really nice!

Tony
