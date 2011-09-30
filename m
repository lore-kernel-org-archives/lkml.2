Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1I3Hqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:46:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35254 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1I3Hqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:46:45 -0400
Date: Fri, 30 Sep 2011 00:46:41 -0700
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] oom: thaw threads if oom killed thread is frozen before
 deferring
Message-ID: <20110930074641.GK10425@mtj.dyndns.org>
References: <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
 <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com>
 <20110928104445.GB15062@tiehlicka.suse.cz>
 <20110929115105.GE21113@tiehlicka.suse.cz>
 <20110929120517.GA10587@redhat.com>
 <20110929130204.GG21113@tiehlicka.suse.cz>
 <20110929163724.GA23773@redhat.com>
 <20110929180021.GA27999@tiehlicka.suse.cz>
 <20110930015148.GD10425@mtj.dyndns.org>
 <20110930074125.GB32134@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930074125.GB32134@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 30, 2011 at 09:41:25AM +0200, Michal Hocko wrote:
> > With pending freezer changes, allowing TIF_MEMDIE tasks to exit
> > freezer by modifying freezing() shouldn't be difficult, which should
> > be race-free and much simpler than diddling with thaw_task().  
> 
> Will the rework help with the initial problem of unkillable OOM selected
> frozen tasks or it will just help with other races that might be present
> with the patch? In other words will this work deprecate the 2 patches
> sent earlier in this thread?

I think it shouldn't be difficult to allow OOM-killing frozen tasks.
That should be good enough, right?

> > How urgent is this?  Can we wait for the next merge window?
> 
> Yes, I think we can wait some more.

I'm still processing rather large backlog.  I'll ping you back once I
sort out the pending freezer changes.

Thanks.

-- 
tejun
