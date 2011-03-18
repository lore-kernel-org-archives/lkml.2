Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1CRHJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:09:42 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:10653 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1CRHJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:09:38 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18pXBXSRKjJMUBLYWk+H5y6
Date: Fri, 18 Mar 2011 00:09:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110318070935.GC3555@atomide.com>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTik_Y1uMfVTVVEdPFG0sjW2uYpeeUMKfymho3sd+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik_Y1uMfVTVVEdPFG0sjW2uYpeeUMKfymho3sd+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [110317 20:00]:
> On Thu, Mar 17, 2011 at 11:30 AM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > Please pull omap changes for this merge window from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus
> 
> Btw, that "generic hardware spinlock" thing needs to be hidden from
> sane people and architectures that don't need it.
> 
> Make platforms that need it "select" it or something. It looks like
> nobody but an OMAP4 could _possibly_ ever want to answer 'y' to that
> question, SO DON'T ASK IT!

No problem, let's make it depends on OMAP4.

Regards,

Tony
