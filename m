Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab1I3IzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:55:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64959 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1I3IzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:55:14 -0400
Date: Fri, 30 Sep 2011 01:55:10 -0700
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
Message-ID: <20110930085510.GA23868@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
 <20110930034815.GF10425@mtj.dyndns.org>
 <1317355529.4588.45.camel@gandalf.stny.rr.com>
 <20110930041424.GH10425@mtj.dyndns.org>
 <1317371699.19415.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317371699.19415.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, Sep 30, 2011 at 10:34:59AM +0200, Peter Zijlstra wrote:
> On Thu, 2011-09-29 at 21:14 -0700, Tejun Heo wrote:
> > It's rather complicated due to the way workqueues have been used.  You
> > can't tell whether a work really needs to be pinned to one cpu for
> > correctness until actual cpu hotplug time as wq users are expected to
> > flush such work items from hotplug notifiers, so wq workers should be
> > pinned on the respective cpus while the cpus are up but also need to
> > step aside once unplug notifiers are finished. 
> 
> That really is crack, and I've always said so.
> 
> How about we fix that utter workqueue unplug nightmare..

The patch is corrupt (=20/=3D's).  Can you please re-send?

Thanks.

-- 
tejun
