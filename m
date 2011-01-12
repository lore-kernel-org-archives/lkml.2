Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1ALG7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:59:31 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32828 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1ALG72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:59:28 -0500
Message-ID: <4D2D514E.5090308@cs.helsinki.fi>
Date: Wed, 12 Jan 2011 08:59:26 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        "=?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?=" <toralf.foerster@gmx.de>,
        "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] kmemleak: Reduce verbosity when memory allocation fails
References: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com> <alpine.DEB.2.00.1101101232580.11969@chino.kir.corp.google.com> <AANLkTik-NwSioPg96EFUDzuK=zK0kNbvUeQbt0rwQAtX@mail.gmail.com> <alpine.DEB.2.00.1101101527580.15655@chino.kir.corp.google.com> <1294749841.4666.49.camel@e102109-lin.cambridge.arm.com> <alpine.DEB.2.00.1101111332330.7551@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1101111332330.7551@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/11 11:34 PM, David Rientjes wrote:
> On Tue, 11 Jan 2011, Catalin Marinas wrote:
>
>> kmemleak: Allow kmemleak metadata allocations to fail
>>
>> From: Catalin Marinas<catalin.marinas@arm.com>
>>
>> This patch adds __GFP_NORETRY and __GFP_NOMEMALLOC flags to the kmemleak
>> metadata allocations so that it has a smaller effect on the users of the
>> kernel slab allocator. Since kmemleak allocations can now fail more
>> often, this patch also reduces the verbosity by passing __GFP_NOWARN and
>> not dumping the stack trace when a kmemleak allocation fails.
>>
>> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
>> Reported-by: Toralf Förster<toralf.foerster@gmx.de>
>> Cc: Pekka Enberg<penberg@cs.helsinki.fi>
>> Cc: David Rientjes<rientjes@google.com>
>> Cc: Ted Ts'o<tytso@mit.edu>
>
> Acked-by: David Rientjes<rientjes@google.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
