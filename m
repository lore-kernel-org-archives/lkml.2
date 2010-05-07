Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0EGTe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:34:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:32828 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab0EGTeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:34:25 -0400
Date: Fri, 7 May 2010 20:33:53 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
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
Message-ID: <20100507193353.GA27175@srcf.ucam.org>
References: <20100507020541.GH30928@atomide.com> <20100507171218.GA23142@srcf.ucam.org> <20100507173549.GF387@atomide.com> <20100507175025.GA23952@srcf.ucam.org> <20100507180152.GH387@atomide.com> <20100507182824.GA25198@srcf.ucam.org> <20100507184333.GL387@atomide.com> <20100507184621.GA25978@srcf.ucam.org> <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com> <20100507192837.GM387@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507192837.GM387@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 12:28:37PM -0700, Tony Lindgren wrote:
> * Daniel Walker <dwalker@fifo99.com> [100507 12:01]:
> > On Fri, 2010-05-07 at 19:46 +0100, Matthew Garrett wrote:
> > > Freezer cgroups would work better, but it doesn't really change the 
> > > point - if that application has an open network socket, how do you know 
> > > to resume that application when a packet comes in?
> 
> No idea, but that still sounds a better situation to me than
> trying to deal with that for a suspended system! :)

Suspend blocks deal with that problem. Nobody has yet demonstrated a 
workable alternative solution.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
