Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0IWJsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:48:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:59929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab0IWJsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:48:00 -0400
Message-ID: <4C9B21FA.4050504@kernel.org>
Date: Thu, 23 Sep 2010 11:46:34 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: linux-next: manual merge of the tip tree with the slab tree
References: <20100923134414.7aa7f696.sfr@canb.auug.org.au> <AANLkTim=uZuC1gt6qL7+KMdgnnx4e4Hh2Zs=SdjJXv5W@mail.gmail.com>
In-Reply-To: <AANLkTim=uZuC1gt6qL7+KMdgnnx4e4Hh2Zs=SdjJXv5W@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Sep 2010 09:46:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 11:33 AM, Pekka Enberg wrote:
> On Thu, Sep 23, 2010 at 6:44 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Today's linux-next merge of the tip tree got a conflict in
>> include/linux/percpu.h between commit
>> 6fc80ef491b981f59233beaf6aeaccc0c947031d ("percpu: use percpu allocator
>> on UP too") from the slab tree and commit
>> 8b8e2ec1eeca7f6941bc81cefc9663018d6ceb57 ("percpu: Add {get,put}
>> _cpu_ptr") from the tip tree.
>>
>> Just context changes.  I fixed it up (see below) and can carry the fix as
>> necessary.
> 
> Why are we seeing a merge conflict here? I cherry-picked patches from
> Tejun's for-next branch but didn't modify them.

That's a different one coming from the perf tree.  get_cpu_ptr() is
only used by perf at this point so it got routed through there, so the
conflict.  Nothing to worry about.

Thanks.

-- 
tejun
