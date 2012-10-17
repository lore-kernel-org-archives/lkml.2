Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2JQVrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:47:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44080 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2JQVrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:47:07 -0400
Date: Wed, 17 Oct 2012 23:47:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH 0/3] perf_event: enable overflow interrupts on KNC
Message-ID: <20121017214700.GA9851@gmail.com>
References: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
 <20121017180753.GA7291@gmail.com>
 <alpine.DEB.2.02.1210171614060.23685@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210171614060.23685@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Wed, 17 Oct 2012, Ingo Molnar wrote:
> 
> > How well tested is this on real hardware and how robust is the 
> > hardware with this? Since it's a new PMU driver for v3.7, and if 
> > these are reasonably well tested, then we could send these to 
> > Linus via perf/urgent, so that they don't miss and have to wait 
> > all the way to v3.8.
> 
> You probably won't like this answer.
> 
> The patches have been tested against the 2.6.34 kernel that 
> Intel provides for KNC (found here 
> http://software.intel.com/en-us/forums/topic/278102 )
> 
> perf stat, perf record, and PAPI have all been tested and 
> work.
>
> The patches I've sent are the 2.6.34 ones forward ported to 
> the 3.7-rc1 kernel.  I haven't been able to run a 3.7-rc 
> kernel on the KNC board, because there are other patches to 
> mainline needed to get KNC running and they'd all have to be 
> forward-ported from 2.6.34.
> 
> Since the knc pmu driver closely models the p6 one, it was 
> straightforward to use it as a basis for the forward port.  
> Everything _should_ work but I've only compile tested.

Ok. As long as it's all identical I'd still be inclined to 
include it in v3.7, to reduce version skew. If the v3.7-rc1 
kernel won't even boot it's not like we'll be able to further 
regress it.

Thanks,

	Ingo
