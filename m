Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0K3WXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:23:39 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48966 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab0K3WXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:23:38 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1snc0ai2x/AkC2Py67ef6
Date: Tue, 30 Nov 2010 14:23:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Message-ID: <20101130222328.GB17222@atomide.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com>
 <20101130190058.GX17222@atomide.com>
 <AANLkTi=73VQeBj_M_PJO5OzJJDgWOXHkw31tN4z-nqMu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=73VQeBj_M_PJO5OzJJDgWOXHkw31tN4z-nqMu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [101130 14:10]:
> On Tue, Nov 30, 2010 at 11:00 AM, Tony Lindgren <tony@atomide.com> wrote:
> > Do we even need the hwspin_lock variants,
> 
> I personally don't have any specific use case in mind.
> 
> It's just a simple wrapper over the _timeout variants, provided for
> API completeness, but -
> 
> > why can't we always use the hwspin_lock_timeout variants?
> 
> We can. I can just remove the _lock variants.

OK sounds good to me.

Tony
