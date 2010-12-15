Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0LOQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:57:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:49667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab0LOQ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:57:36 -0500
Message-ID: <4D08F362.4000808@kernel.org>
Date: Wed, 15 Dec 2010 17:57:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 4/4] Lockless (and preemptless) fastpaths
 for slub
References: <20101214174847.887713690@linux.com>	<20101214174901.827380447@linux.com>	<4D08F21B.3000706@kernel.org> <AANLkTik8Wnhvr+7h=rwpxmBHSnyvdT0uu77CMELTVUTd@mail.gmail.com>
In-Reply-To: <AANLkTik8Wnhvr+7h=rwpxmBHSnyvdT0uu77CMELTVUTd@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Dec 2010 16:57:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On 12/15/2010 05:55 PM, Pekka Enberg wrote:
> On Wed, Dec 15, 2010 at 6:51 PM, Tejun Heo <tj@kernel.org> wrote:
>> The first two look good to me but I frankly don't have much idea about
>> the latter two.  Pekka, can you please ack those?  Alternatively, you
>> can later pull the percpu tree in and apply the allocator bits in your
>> tree, which I actually prefer.
> 
> I'd prefer to pull the first two from your tree and put the allocator
> changes to slab.git.

Great, then I'll let you know after the percpu tree is frozen with the
new changes.

Thanks.

-- 
tejun
