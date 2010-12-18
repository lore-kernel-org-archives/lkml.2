Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0LRAxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:53:22 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:27344 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0LRAxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:53:20 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XLeT8JRQvCi5T0dwlh/w7
Date: Fri, 17 Dec 2010 16:53:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
Message-ID: <20101218005311.GE5941@atomide.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
 <20101214170656.GA3832@kroah.com>
 <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
 <20101216210837.GA22895@kroah.com>
 <AANLkTi=s_Urcin4SAp1mXrKmoyzR2=6YuS3aU+OYYgqK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=s_Urcin4SAp1mXrKmoyzR2=6YuS3aU+OYYgqK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [101216 13:34]:
> On Thu, Dec 16, 2010 at 11:08 PM, Greg KH <greg@kroah.com> wrote:
> >> > I've seen a lot of discussion about this, are all of the review comments
> >> > now addressed?
> >>
> >> Yes, all comments were addressed in this v3 iteration, and this thread
> >> has been idle for about 10 days.
> >
> > That's because we are all busy with other things :(
> 
> Oh sure, my intention was only positive (to demonstrate that there are
> no outstanding comments), sorry if it sounded differently than
> intended.
> 
> > Sorry, I really don't have the time at the moment to review this code,
> > nor does it seem to affect areas that I maintain, so I don't understand
> > what you are looking for from me.
> 
> Sorry for the noise - I contacted you because you maintain the driver
> core, in the hope you could suggest where this can go through.
> 
> Tony, Andrew, can you please have a look ?
> 
> Any comment or suggestion is appreciated.

Looks sane to me from omap point of view and it seems the locks
are now all timeout based:

Acked-by: Tony Lindgren <tony@atomide.com>

Regards,

Tony
