Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab0EGWAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:00:45 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51942 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0EGWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:00:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/fHZ7aLc2zLmaeAFZHtLK6
Date: Fri, 7 May 2010 15:00:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507220026.GS387@atomide.com>
References: <20100507192837.GM387@atomide.com>
 <20100507193353.GA27175@srcf.ucam.org>
 <20100507195548.GN387@atomide.com>
 <20100507202859.GA27328@srcf.ucam.org>
 <20100507205329.GP387@atomide.com>
 <20100507210304.GA28701@srcf.ucam.org>
 <20100507212556.GQ387@atomide.com>
 <20100507213917.GE28906@srcf.ucam.org>
 <20100507214211.GR387@atomide.com>
 <20100507214855.GA30190@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507214855.GA30190@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100507 14:44]:
> On Fri, May 07, 2010 at 02:42:11PM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100507 14:34]:
> > > How do you know to wake the process up in response to the keypress?
> > 
> > Does it matter for processes that are not "certified"? Maybe you
> > could assume that you can keep it stopped until the screen is on
> > again, or some other policy.
> 
> Yes, it matters. You don't necessarily know whether to turn the screen 
> on until the app has had an opportunity to process the event. This is 
> exactly the kind of use case that suspend blocks are intended to allow, 
> so alternatives that don't permit that kind of use case aren't really 
> adequate alternatives.

Hmm, I'm thinking there would not be any need to turn the screen on
for the broken apps until some other event such as a tap on the screen
triggers the need to turn the screen on.

If it's a critical app, then it should be fixed so it's safe to keep
running.

And yeah, I guess you could cgroups to categorize "timer certified"
and "broken" apps.

Regards,

Tony
