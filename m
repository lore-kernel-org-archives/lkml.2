Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2DRUSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:18:14 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:36979 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2DRUSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:18:12 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/dH9ib8DA6Q6rQ04zGI0kq
Date: Wed, 18 Apr 2012 13:18:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 02/10] ARM: OMAP2+: SmartReflex: move the platform
 specific macros in plat-omap
Message-ID: <20120418201807.GQ21106@atomide.com>
References: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
 <1331829845-9526-3-git-send-email-j-pihet@ti.com>
 <20120315171359.GA7276@atomide.com>
 <CAORVsuUp9VBX1XbkQkcq91XsbRSut1RC6KCNPFHrX+RfWv7hQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAORVsuUp9VBX1XbkQkcq91XsbRSut1RC6KCNPFHrX+RfWv7hQA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jean Pihet <jean.pihet@newoldbits.com> [120316 08:22]:
> Hi Tony,
> 
> On Thu, Mar 15, 2012 at 6:14 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> [120315 09:47]:
> >> From: Jean Pihet <j-pihet@ti.com>
> >>
> >> Move the platform specific macros from the smartreflex header file
> >> (arch/arm/mach-omap2/smartreflex.h) in a new header file in plat-omap
> >> (arch/arm/plat-omap/include/plat/smartreflex.h).
> >>
> >> This change makes the SmartReflex implementation ready for the move
> >> to drivers/.
> >
> > Glad to see this happening!
> >
> > This would be better located in linux/power/smartreflex.h rather than
> > plat/smartreflex.h.
> Ok. Is the file name still Ok in that case? Should it mention OMAP?

Well I guess smartreflex is enough, in theory it could be on other
processors than omap too.

Tony
