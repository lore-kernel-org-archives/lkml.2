Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2KBIaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:30:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54888 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab2KBIaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121101170454.b7713bce.akpm@linux-foundation.org>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<20121101170454.b7713bce.akpm@linux-foundation.org>
Date: Fri, 2 Nov 2012 10:30:06 +0200
X-Google-Sender-Auth: tpDiSxVo2gZFizqZP63-q8VZthk
Message-ID: <CAOJsxLH7w_qvMofLD3sNuWpyJ0FO8CNHVnYo03TvY46R2qryog@mail.gmail.com>
Subject: Re: [PATCH v6 00/29] kmem controller for memcg.
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 2:04 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> One thing:
>
>> Numbers can be found at https://lkml.org/lkml/2012/9/13/239
>
> You claim in the above that the fork worload is 'slab intensive".  Or
> at least, you seem to - it's a bit fuzzy.
>
> But how slab intensive is it, really?
>
> What is extremely slab intensive is networking.  The networking guys
> are very sensitive to slab performance.  If this hasn't already been
> done, could you please determine what impact this has upon networking?
> I expect Eric Dumazet, Dave Miller and Tom Herbert could suggest
> testing approaches.

IIRC, networking guys have reduced their dependency on slab
performance recently.

Few simple benchmarks to run are hackbench, netperf, and Christoph's
famous microbenchmarks. The sad reality is that you usually have to
wait for few release cycles before people notice that you've destroyed
performance of their favourite workload. :-/
