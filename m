Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2FFIWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:22:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33098 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab2FFIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:22:36 -0400
Date: Wed, 6 Jun 2012 10:22:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 4/8] x86: apic: Factor out default
 vector_allocation_domain() operations
Message-ID: <20120606082231.GD5991@gmail.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/include/asm/apic.h           |   21 +++++++++++++++++++++
>  arch/x86/include/asm/x2apic.h         |    9 ---------
>  arch/x86/kernel/apic/apic_flat_64.c   |   22 +---------------------
>  arch/x86/kernel/apic/apic_noop.c      |    3 +--
>  arch/x86/kernel/apic/apic_numachip.c  |    8 +-------
>  arch/x86/kernel/apic/bigsmp_32.c      |    8 +-------
>  arch/x86/kernel/apic/es7000_32.c      |   19 ++-----------------
>  arch/x86/kernel/apic/numaq_32.c       |   16 +---------------
>  arch/x86/kernel/apic/probe_32.c       |   17 +----------------
>  arch/x86/kernel/apic/summit_32.c      |   16 +---------------
>  arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
>  arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
>  arch/x86/kernel/apic/x2apic_uv_x.c    |    8 +-------
>  13 files changed, 33 insertions(+), 118 deletions(-)

Nice cleanups.

This one didn't apply due to the following fresh patch in -tip:

0b8255e660a0 x86/x2apic/cluster: Use all the members of one cluster specified in the smp_affinity 

So I applied the first three to tip:x86/apic, mind sending the 
remaining 4 patches on top of -tip?

Thanks,

	Ingo
