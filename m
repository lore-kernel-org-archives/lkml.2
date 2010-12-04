Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0LDTb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 14:31:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:54555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab0LDTb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 14:31:56 -0500
Message-ID: <4CFA970D.1080400@kernel.org>
Date: Sat, 04 Dec 2010 20:31:25 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [rfc: cpuops adv V1 0/8] Cmpxchg and xchg support for cpu ops
References: <20101202215340.562309713@linux.com> <4CFA9685.20200@cs.helsinki.fi>
In-Reply-To: <4CFA9685.20200@cs.helsinki.fi>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 04 Dec 2010 19:31:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/04/2010 08:29 PM, Pekka Enberg wrote:
> [ Sorry for the delay everyone. ]
> 
> Christoph, do you mind sending me a series that you think is stable
> enough for linux-next? The numbers are pretty impressive and I'd
> love to give them some testing locally and in linux-next.
>
> How should we coordinate the per-CPU ops patches, btw? We had
> pretty good experience with the per-cpu allocator patches where
> Tejun merged the patches in his tree and I pulled it in
> slab.git. Who handles the per-cpu ops?

I'll be happy to apply the per-cpu ops part.  Christoph, would it be
okay to apply patches from this posting?

Thanks.

-- 
tejun
