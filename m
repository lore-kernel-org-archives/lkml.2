Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0EGT2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:28:54 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52138 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab0EGT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:28:52 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19RphZGYXeJXGjmOgHr7ify
Date: Fri, 7 May 2010 12:28:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
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
Message-ID: <20100507192837.GM387@atomide.com>
References: <20100506184418.GA30669@srcf.ucam.org>
 <20100507020541.GH30928@atomide.com>
 <20100507171218.GA23142@srcf.ucam.org>
 <20100507173549.GF387@atomide.com>
 <20100507175025.GA23952@srcf.ucam.org>
 <20100507180152.GH387@atomide.com>
 <20100507182824.GA25198@srcf.ucam.org>
 <20100507184333.GL387@atomide.com>
 <20100507184621.GA25978@srcf.ucam.org>
 <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker <dwalker@fifo99.com> [100507 12:01]:
> On Fri, 2010-05-07 at 19:46 +0100, Matthew Garrett wrote:
> > On Fri, May 07, 2010 at 11:43:33AM -0700, Tony Lindgren wrote:
> > > * Matthew Garrett <mjg@redhat.com> [100507 11:23]:
> > > > On Fri, May 07, 2010 at 11:01:52AM -0700, Tony Lindgren wrote:
> > > > > * Matthew Garrett <mjg@redhat.com> [100507 10:46]:
> > > > > > Effective power management in the face of real-world applications is a 
> > > > > > reasonable usecase.
> > > > > 
> > > > > Sure there's no easy solution to misbehaving apps.
> > > > 
> > > > That's the point of the suspend blockers.
> > > 
> > > To me it sounds like suspending the whole system to deal with
> > > some misbehaving apps is an overkill. Sounds like kill -STOP
> > > the misbehaving apps should do the trick?
> > 
> > Freezer cgroups would work better, but it doesn't really change the 
> > point - if that application has an open network socket, how do you know 
> > to resume that application when a packet comes in?

No idea, but that still sounds a better situation to me than
trying to deal with that for a suspended system! :)
 
> suspend blockers can get abused also .. I had my phone in my pocket and
> accidentally ran "Google Talk" or something. It must have kept the
> screen on or kept the phone from suspending, so the battery drained
> completely over the course of an hour or so.

Yeah I guess there's nothing stopping that.

Tony

