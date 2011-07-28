Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1G1Kkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:40:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55210 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1G1Kkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:40:45 -0400
Date: Thu, 28 Jul 2011 13:40:36 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: torvalds@linux-foundation.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v3.1-rc0
In-Reply-To: <1311576942.6669.20.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1107281337470.2841@tiger>
References: <alpine.DEB.2.00.1107221108190.2996@tiger> <1311576942.6669.20.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1827813833-1311849641=:2841"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1827813833-1311849641=:2841
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Le vendredi 22 juillet 2011 à 11:08 +0300, Pekka Enberg a écrit :
>> Here's batch of slab/slub/slob changes accumulated over the past few months.
>> The biggest changes are alignment unification from Christoph Lameter and SLUB
>> debugging improvements from Ben Greear. Also notable is SLAB 'struct
>> kmem_cache' shrinkage from Eric Dumazet that helps large SMP systems.

On Mon, 25 Jul 2011, Eric Dumazet wrote:
>> Please note that the SLUB lockless slowpath patches will be sent in a separate
>> pull request.
>>
>>                          Pekka
>
> Hi Pekka
>
> Could we also merge in 3.1 following "simple enough" patch ?
>
> Thanks
>
> [PATCH] slab: remove one NR_CPUS dependency
>
> Reduce high order allocations in do_tune_cpucache() for some setups.
> (NR_CPUS=4096 -> we need 64KB)
>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@kernel.org>

Sorry for the delay. I applied the patch and will send it to Linus within 
few days.

 			Pekka
--8323329-1827813833-1311849641=:2841--
