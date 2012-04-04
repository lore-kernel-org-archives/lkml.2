Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2DDMa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:30:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab2DDMax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:30:53 -0400
Message-ID: <1333542649.7188.40.camel@marge.simpson.net>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
From: Mike Galbraith <mgalbraith@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 04 Apr 2012 14:30:49 +0200
In-Reply-To: <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com>
	 <1333535915.7188.18.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 04:29 -0700, David Rientjes wrote:

> I've never seen a nack from Peter on this, I only remember discussing 
> whether this needs to be isolated to only cpusets or whether it needs to 
> be a generic cgroup thing and I've always argued in favor of localizing it 
> to cpusets because that cgroup happens to care about cpu affinity where 
> others don't and this is why cgroups have ->can_attach() functions.  If a 
> cgroup were created to have nothing to do with cpu affinity (only for 
> collecting statistics for threads within it, for example), there's 
> absolutely no reason why we need to exclude kthreadd.

Well, he didn't actually say "NAK", but was against it, which means
pretty much the same thing as NAK to me.. we can call it a nak.

> You know I've been very supportive of getting this fix included for 
> cpusets in the past and I very much appreciate your time and patience in 
> the review cycle.  I'm hoping we can finally do this.

Whatever floats the boat works for me.  Peter likes generic, you like
targeted.  I like generic best too fwtw, but I don't get to make the
command decision, else you'd be saying revert, and I'd be saying NAK :)

-Mike

