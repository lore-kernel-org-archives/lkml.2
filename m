Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0EGSnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:43:53 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:61513 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996Ab0EGSns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:43:48 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+/i3/BniSver0muhmxo/lz
Date: Fri, 7 May 2010 11:43:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Brian Swetland <swetland@google.com>,
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
Message-ID: <20100507184333.GL387@atomide.com>
References: <20100506173807.GD30928@atomide.com>
 <20100506174331.GA29103@srcf.ucam.org>
 <20100506183335.GE30928@atomide.com>
 <20100506184418.GA30669@srcf.ucam.org>
 <20100507020541.GH30928@atomide.com>
 <20100507171218.GA23142@srcf.ucam.org>
 <20100507173549.GF387@atomide.com>
 <20100507175025.GA23952@srcf.ucam.org>
 <20100507180152.GH387@atomide.com>
 <20100507182824.GA25198@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507182824.GA25198@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100507 11:23]:
> On Fri, May 07, 2010 at 11:01:52AM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100507 10:46]:
> > > Effective power management in the face of real-world applications is a 
> > > reasonable usecase.
> > 
> > Sure there's no easy solution to misbehaving apps.
> 
> That's the point of the suspend blockers.

To me it sounds like suspending the whole system to deal with
some misbehaving apps is an overkill. Sounds like kill -STOP
the misbehaving apps should do the trick?

Tony
