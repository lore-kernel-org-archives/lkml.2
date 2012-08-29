Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2H2I2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:28:22 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40852 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab2H2I2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:28:18 -0400
Date: Wed, 29 Aug 2012 12:27:53 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and
 sched_switch events (v2)
Message-ID: <20120829082752.GA4638@avaginn.sw.ru>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
 <1344344165-369636-4-git-send-email-avagin@openvz.org>
 <m2ehms6ouh.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <m2ehms6ouh.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 12:51:02AM +0400, Andi Kleen wrote:
> Andrew Vagin <avagin@openvz.org> writes:
> >
> > My code saves sched_switch event for each process and when it meets
> > stat_iowait, it reports the sched_switch event, because this event
> > contains a correct callchain. By another words it replaces all
> > stat_iowait events on proper sched_switch events.
> 
> Is there any way to generalize this to arbitary events? I found myself
> writing scripts to compute lengths between various events.  But I
> presume this could be done in a more general way. The advantage
> of perf-inject over my script is that the output can be viewed
> in the normal browser.

I don't know what do you mean to generalize this to arbitary events.
I think a generalization will be obvious, when we will have a few
examples.

Currently we can modify events by a simple way.
What would I want to have? It's a way to create a new event type and
events in "perf inject".

> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
