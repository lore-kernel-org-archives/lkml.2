Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab0EGUxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:53:48 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62206 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab0EGUxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:53:47 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19a5H+jtK5HeO38QgQJRoPY
Date: Fri, 7 May 2010 13:53:29 -0700
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
Message-ID: <20100507205329.GP387@atomide.com>
References: <20100507175025.GA23952@srcf.ucam.org>
 <20100507180152.GH387@atomide.com>
 <20100507182824.GA25198@srcf.ucam.org>
 <20100507184333.GL387@atomide.com>
 <20100507184621.GA25978@srcf.ucam.org>
 <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
 <20100507192837.GM387@atomide.com>
 <20100507193353.GA27175@srcf.ucam.org>
 <20100507195548.GN387@atomide.com>
 <20100507202859.GA27328@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507202859.GA27328@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100507 13:24]:
> On Fri, May 07, 2010 at 12:55:48PM -0700, Tony Lindgren wrote:
> 
> > - Deal with broken apps whichever way you want in the userspace.
> 
> If we could do this then there would be no real need for suspend 
> blockers.

OK, I guess I don't understand all the details, need some kind
of common example I guess.

So for example, if I leave ping running in a a terminal, do you
have some way of preventing that from eating the battery?

In my scenario that program would keep on running until the
battery runs out, or something stops the program. But the system
keeps hitting retention mode in the idle loop.

How do you deal with programs like that?

Do you just suspend the whole system anyways at some point,
or do you have some other trick?

Regards,

Tony
