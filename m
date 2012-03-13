Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2CMNti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:49:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab2CMNth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:49:37 -0400
Date: Tue, 13 Mar 2012 09:49:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120313134922.GB29169@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312221050.GG23255@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 03:10:50PM -0700, Tejun Heo wrote:
> Hello, guys.
> 
> Thanks a lot for the discussion and here are my take aways:
> 
> * At least to me, nobody seems to have strong enough justification for
>   orthogonal multiple hierarchies, so, yeah, unless something else
>   happens, I'm scheduling multiple hierarchy support for the chopping
>   block.  This is a long term thing (think years), so no need to panic
>   right now and as is life plans may change and fail to materialize,
>   but I intend to at least move away from it.

So everything will be under single hierarchy? How will we control that
what controllers are active on what cgroups? Or all controllers are going
to be active on all cgroups on that hierarchy. 

That would be bad for IO cgroups where a better way to use it to isolate
the trouble making workload and run rest in root or a common cgroup.

Thanks
Vivek
