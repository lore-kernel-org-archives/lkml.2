Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0EMVh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:37:26 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56795 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821Ab0EMVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:37:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19r9e6Cb76lW+H6k4TsnPuK
Date: Thu, 13 May 2010 14:36:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>,
       Brian Swetland <swetland@google.com>, Paul Walmsley <paul@pwsan.com>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Greg KH <gregkh@suse.de>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513213656.GL3428@atomide.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <201005132311.26293.rjw@sisk.pl>
 <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com>
 <201005132327.16163.rjw@sisk.pl>
 <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker <dwalker@fifo99.com> [100513 14:28]:
> On Thu, 2010-05-13 at 23:27 +0200, Rafael J. Wysocki wrote:
> 
> > Because someone would have to remove suspend blockers (or rather wakelocks)
> > from the drivers, test that they work correctly without suspend blockers and
> > submit the modified versions.  Going forward, every party responsible for such
> > a driver would have to maintain an out-of-tree version with suspend blockers
> > (or wakelocks) anyway, so the incentive to do that is zero.
> 
> They should work without wakelock since wakelock are optional .. I mean
> there's nothing in suspend blockers I've seen that indicates it's
> required for some drivers to work. So it's just a matter of patching out
> the wakelocks, with no need to re-test anything.
> 
> You get the driver mainlined, then maintain a small patch to add
> wakelocks. Not hard at all , with lots of incentive to do so since you
> don't have to maintain such a large block of code out of tree.
> 
> > Practically, as long as the opportunistic suspend is out of tree, there will be
> > a _growing_ number of out-of-tree drivers out there, which is not acceptable
> > in the long run.
> 
> I don't see why your saying that. These driver should work with out all
> of this, which means they can get mainlined right now.

I agree with Daniel here. We should keep merging the drivers separate
from the suspend blocks issues.

Regards,

Tony
