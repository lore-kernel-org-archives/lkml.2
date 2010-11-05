Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0KEQpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:45:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:33526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0KEQpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:45:39 -0400
Message-ID: <4CD43497.1020907@kernel.org>
Date: Fri, 05 Nov 2010 17:45:11 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] irq: use per_cpu kstat_irqs
References: <1288892908.2659.175.camel@edumazet-laptop> <1288973210.2882.733.camel@edumazet-laptop>
In-Reply-To: <1288973210.2882.733.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Nov 2010 16:45:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/05/2010 05:06 PM, Eric Dumazet wrote:
> V2: support for !CONFIG_SPARSE_IRQ
>     No white space changes.
> 
> Question : Is dynamic percpu allocator ready at this stage for all
> arches ? The need is NR_IRQS*4 bytes of percpu memory for 
> !CONFIG_SPARSE_IRQ

The earliest is early_irq_init(), right?  If so, percpu allocator is
up by then on all archs.

Thanks.

-- 
tejun
