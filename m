Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1ITXNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 19:13:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:37071 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752382Ab1ITXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 19:13:48 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/WYfxEwtLUWCIBlCaB/5hV
Date: Tue, 20 Sep 2011 16:13:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/10] hwspinlock-next
Message-ID: <20110920231340.GT18894@atomide.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
 <CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [110920 01:34]:
> On Mon, Sep 12, 2011 at 7:46 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> 
> I'm wondering how hwspinlock updates like this should go upstream.
> 
> The first hwspinlock batch was picked by Tony, because it involved a
> bulk of OMAP changes.
> 
> Hwspinlock isn't OMAP-specific anymore though (we gained support for
> STE's u8500) and the vast majority of changes are in drivers/. We're
> still very much ARM-related, though this may change too at some point
> (c6x has a similar "hardware semaphore" peripheral like the u8500
> does).
> 
> Tony, if you're still willing to pick up these updates I'd be happy to
> send you pull requests of course.

I'd prefer for Greg to take these as these are drivers.

If he's not taking it at this point based on it being ARM only,
I can take it then.

Regards,

Tony
