Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1C3QAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:00:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab1C3QAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:00:10 -0400
Message-ID: <4D93531F.5080403@zytor.com>
Date: Wed, 30 Mar 2011 08:58:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH tip:x86/mm 1/3] x86: A fast way to check capabilities
 of the current cpu
References: <20110312115010.GC2005@htj.dyndns.org> <m2k4g1zdmt.fsf@firstfloor.org>
In-Reply-To: <m2k4g1zdmt.fsf@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 12:49 PM, Andi Kleen wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Add this_cpu_has() which determines if the current cpu has a certain
>> ability using a segment prefix and a bit test operation.
> 
> 
> Hmm: if the CPU capability is really tested in a performance critical
> path, wouldn't it even be better to just use static_branch() now? 
> 

We have static_cpu_has() for this specific purpose (it actually predates
static_branch()).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

