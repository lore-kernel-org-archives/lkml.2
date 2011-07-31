Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1GaQNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 12:13:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64822 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1GaQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 12:13:07 -0400
Date: Sun, 31 Jul 2011 19:12:59 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Christoph Lameter <cl@linux.com>
cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v3.1-rc0
In-Reply-To: <alpine.DEB.2.00.1107291023000.16178@router.home>
Message-ID: <alpine.DEB.2.00.1107311912380.9837@tiger>
References: <alpine.DEB.2.00.1107221108190.2996@tiger> <CAOJsxLHniS9Hx+ep_i2qbE_Oo6PnkNCK5dNARW5egg9Bso4Ovg@mail.gmail.com> <alpine.DEB.2.00.1107281514080.29344@chino.kir.corp.google.com> <alpine.DEB.2.00.1107291023000.16178@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 28 Jul 2011, David Rientjes wrote:
>
>> On Thu, 28 Jul 2011, Pekka Enberg wrote:
>>
>>> Christoph, your debugging fix has been in linux-next for few days now
>>> and no problem have been reported. I'm considering sending the series
>>> to Linus. What do you think?
>>>
>>
>> I ran slub/lockless through some stress testing and it seems to be quite
>> stable on my testing cluster.  There is about a 2.3% performance
>> improvement with the lockless slowpath on the netperf benchmark with
>> various thread counts on my 16-core 64GB Opterons, so I'd recommend it to
>> be merged into 3.1.

On Fri, 29 Jul 2011, Christoph Lameter wrote:
> Great. Could you also test the next stage of patches (not yet even in
> Pekka's tree) where we add a per cpu cache of partial allocated slab
> pages? This decreases the per node lock contention further. I can repost
> the set if the old one does not work for you. Shows significant
> improvement here as well.

They don't apply so please resend them.

 			Pekka
