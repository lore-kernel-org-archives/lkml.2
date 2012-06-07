Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab2FGWZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:25:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:17186 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212Ab2FGWZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:25:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109286282"
Subject: Re: [PATCH 4/8] x86/apic: Factor out default
 vector_allocation_domain() operation
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Thu, 07 Jun 2012 15:24:47 -0700
In-Reply-To: <20120607131449.GC4759@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
	 <20120606082231.GD5991@gmail.com>
	 <20120607131449.GC4759@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339107887.28766.105.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 15:14 +0200, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/include/asm/apic.h          |   21 +++++++++++++++++++++
>  arch/x86/kernel/apic/apic_flat_64.c  |   22 +---------------------
>  arch/x86/kernel/apic/apic_noop.c     |    3 +--
>  arch/x86/kernel/apic/apic_numachip.c |    8 +-------
>  arch/x86/kernel/apic/bigsmp_32.c     |    8 +-------
>  arch/x86/kernel/apic/es7000_32.c     |   19 ++-----------------
>  arch/x86/kernel/apic/numaq_32.c      |   16 +---------------
>  arch/x86/kernel/apic/probe_32.c      |   17 +----------------
>  arch/x86/kernel/apic/summit_32.c     |   16 +---------------
>  arch/x86/kernel/apic/x2apic_phys.c   |   11 +----------
>  arch/x86/kernel/apic/x2apic_uv_x.c   |    8 +-------
>  11 files changed, 32 insertions(+), 117 deletions(-)
> 

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

