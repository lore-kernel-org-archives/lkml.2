Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab0EMVfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:35:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49265 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0EMVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:35:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Z8chVTPxKXQuFcB5o8LUk
Date: Thu, 13 May 2010 14:34:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513213455.GK3428@atomide.com>
References: <20100513191717.GA3428@atomide.com>
 <20100513192522.GA19256@srcf.ucam.org>
 <20100513194205.GC3428@atomide.com>
 <20100513195349.GB19722@srcf.ucam.org>
 <20100513200003.GE3428@atomide.com>
 <20100513200814.GA20254@srcf.ucam.org>
 <20100513202320.GF3428@atomide.com>
 <20100513203412.GA21244@srcf.ucam.org>
 <20100513211006.GG3428@atomide.com>
 <20100513212108.GA22103@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513212108.GA22103@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100513 14:16]:
> On Thu, May 13, 2010 at 02:10:06PM -0700, Tony Lindgren wrote:
> > * Matthew Garrett <mjg@redhat.com> [100513 13:29]:
> > > And if that's the application that's listening to the network socket 
> > > that you want to get a wakeup event from? This problem is hard. I'd love 
> > > there to be an elegant solution based on using the scheduler, but I 
> > > really don't know what it is.
> > 
> > Your system should wake up to an interrupt in that case. Then you have
> > the trusted apps running that can decide if the untrusted apps should
> > be continued or not.
> 
> What race-free mechanism do you use to ensure that? It's very easy to 
> handwave these problems away. It's very difficult to actually write an 
> implementation that works.

Can you describe where do you see the race now?

Your trusted apps should be have in quite a normal way except the system
suspends if no critical timers are on the list. For the untrusted apps
you assume you can stop them at whatever userspace policy you set.

Regards,

Tony
