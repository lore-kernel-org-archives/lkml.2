Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0EGW2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:28:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45286 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab0EGW2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:28:44 -0400
Date: Fri, 7 May 2010 23:28:09 +0100
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
Message-ID: <20100507222809.GA30808@srcf.ucam.org>
References: <20100507193353.GA27175@srcf.ucam.org> <20100507195548.GN387@atomide.com> <20100507202859.GA27328@srcf.ucam.org> <20100507205329.GP387@atomide.com> <20100507210304.GA28701@srcf.ucam.org> <20100507212556.GQ387@atomide.com> <20100507213917.GE28906@srcf.ucam.org> <20100507214211.GR387@atomide.com> <20100507214855.GA30190@srcf.ucam.org> <20100507220026.GS387@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507220026.GS387@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 03:00:26PM -0700, Tony Lindgren wrote:

> Hmm, I'm thinking there would not be any need to turn the screen on
> for the broken apps until some other event such as a tap on the screen
> triggers the need to turn the screen on.
> 
> If it's a critical app, then it should be fixed so it's safe to keep
> running.
> 
> And yeah, I guess you could cgroups to categorize "timer certified"
> and "broken" apps.

This is a perfectly valid model, but it's not one that matches Android.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
