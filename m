Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0LFRPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:15:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab0LFRPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:15:40 -0500
Message-ID: <4CFD1A05.3020900@redhat.com>
Date: Mon, 06 Dec 2010 19:14:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [rfc: cpuops adv V1 3/8] x86: this_cpu_cmpxchg and this_cpu_cmpxchg_double
 operations
References: <20101202215340.562309713@linux.com> <20101202215400.609058574@linux.com>
In-Reply-To: <20101202215400.609058574@linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 11:53 PM, Christoph Lameter wrote:
> Provide support as far as the hardware capabilities of the x86 cpus
> allow.
>
>
>
> +/*
> + * Beware: xchg on x86 has an implied lock prefix. There will be the cost of
> + * full lock semantics even though they are not needed.
> + */

Perhaps we can use cmpxchg instead of xchg to avoid this? costs one more 
instruction but may be worth it.

-- 
error compiling committee.c: too many arguments to function

