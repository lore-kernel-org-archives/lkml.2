Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0EFSdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:33:50 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50110 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0EFSds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:33:48 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18jR9Ez7JwC34gG8c4LB5MP
Date: Thu, 6 May 2010 11:33:35 -0700
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
Message-ID: <20100506183335.GE30928@atomide.com>
References: <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
 <20100505234755.GI29604@atomide.com>
 <20100506134015.GA23426@srcf.ucam.org>
 <20100506170151.GA30928@atomide.com>
 <20100506170956.GA28104@srcf.ucam.org>
 <20100506171453.GC30928@atomide.com>
 <20100506172201.GA28578@srcf.ucam.org>
 <20100506173807.GD30928@atomide.com>
 <20100506174331.GA29103@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506174331.GA29103@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100506 10:39]:
> On Thu, May 06, 2010 at 10:38:08AM -0700, Tony Lindgren wrote:
> 
> > If your userspace keeps polling and has runaway timers, then you
> > could suspend it's parent process to idle the system?
> 
> If your userspace is suspended, how does it process the events that 
> generated a system wakeup? If we had a good answer to that then suspend 
> blockers would be much less necessary.

Well if your hardware runs off-while-idle or even just
retention-while-idle, then the basic shell works just fine waking up
every few seconds or so.

Then you could keep init/shell/suspend policy deamon running until
it's time to suspend the whole device. To cut down runaway timers,
you could already freeze the desktop/GUI/whatever earlier.

Regards,

Tony

