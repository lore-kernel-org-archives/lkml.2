Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1LFXxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:53:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54856 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1LFXxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:53:51 -0500
Date: Tue, 6 Dec 2011 15:53:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>
cc: Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch-final] Re: patch] cpusets, cgroups: disallow attaching
 kthreadd
In-Reply-To: <20111206144721.7b1d473d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1112061547530.15884@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net> <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com> <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net> <1318233815.6527.5.camel@marge.simson.net>
 <1318925436.9641.23.camel@marge.simson.net> <CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com> <1319001860.6222.34.camel@marge.simson.net> <alpine.DEB.2.00.1110261326550.23111@chino.kir.corp.google.com> <alpine.DEB.2.00.1111101251070.21036@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1112061212510.28251@chino.kir.corp.google.com> <20111206144721.7b1d473d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, Andrew Morton wrote:

> > Ping #2?
> > 
> 
> Why am I being pinged about scheduler patches?  My sole contribution
> to this one is to point out that "its"->possessive and "it's"->"it is".
> 

It touches two areas and there's probably a counter argument on the 
otherside about wanting to apply cpuset patches, which typically go 
through -mm.  It's a patch that, as the changelog indicates, fixes cpusets 
from becoming immortal if their set of tasks can never be emptied.  Would 
you like the change separated into kernel/cpuset.c and kernel/sched.c 
portions each referring to each other?

> Also, Peter has said
> 
> : I really think that if we want to restrain userspace from doing
> : something stupid we might as well do something that makes sense, and
> : that is mandate kthreadd stays in the root group at all times for
> : everybody.
> 
> which appears to be what the patch already did, so I'm confused again.
> 

Yes, that's what the patch does.  I'm not sure that Peter's explanation 
above is any better than what Mike wrote in the changelog, though, the 
changelog states why allowing kthreadd to move to a cpuset is actually 
troublesome.

> It's time for a fresh resend, IMO.
> 

Mike, would you mind resending the patch for the fourth or fifth time?  If 
not, I'll rebase it.
