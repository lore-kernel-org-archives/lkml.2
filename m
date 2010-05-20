Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab0ETSuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:50:37 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:56808 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab0ETSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:50:36 -0400
Date: Thu, 20 May 2010 21:50:57 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: David Brownell <david-b@pacbell.net>
Cc: felipe.balbi@nokia.com, Vladimir Pantelic <pan@nt.tu-darmstadt.de>,
       Matthew Garrett <mjg@redhat.com>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Brian Swetland <swetland@google.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100520185057.GA25089@gandalf>
Reply-To: me@felipebalbi.com
References: <4BF51C9D.8050406@nt.tu-darmstadt.de>
 <15003.23611.qm@web180316.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15003.23611.qm@web180316.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 10:40:17AM -0700, David Brownell wrote:
> Some apps do abuse kernel mechanisms, and whether the bug is in the
> app or that kernel mechanism can be a judgement call.  I'd expect to

hey come on, there's no judgement call for an app polling every second
to check battery status or some other status that doesn't change that
frequently.

> I may have overlooked it, in one of the 100K messsages in my mailbox
> about versions of suspend block/etc patches ...
> 
> But surely NOBODY is actually contending that broken aps NOT get
> fixed??
> 
> It's clear to me that tools are needed to identify power hogs;
> powertop can't be the extent of such tools.  (ISTR it doesn't monitor
> display power usage, for one thing; maybe newer versions do so.)  Once
> such hogs get identified they will need to get fixed.  Any other
> proposal seems broken to me...

that's my feeling too. I don't see any needs for suspend blockers in any
real system. I acknowledge we need tools probing power consumption to be
shipped to production device, that's a good idea, but forcing apps to
modify just to have that UI fill up some treeview, I think it's a bit
too much.

-- 
balbi
