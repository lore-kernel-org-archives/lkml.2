Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2K1VKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:10:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32129 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2K1VKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:10:30 -0500
Date: Wed, 28 Nov 2012 16:09:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 00/19 v4] Improve IRQ remapping abstraction in x86 core
 code
Message-ID: <20121128210949.GC13915@phenom.dumpdata.com>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:12:37PM +0100, Joerg Roedel wrote:
> Hi,
> 
> here is the fourth version of the patch-set to improve the abstraction
> of interrupt remapping in the x86 core code. A more detailed description
> can be found in the original post at:

Are these patches available on some git tree?

> 
>         https://lkml.org/lkml/2012/8/7/317
> 
> Changes from v3->v4:
> 
> 	* Rebased to v3.7-rc6
> 	* Added Acked-bys
> 	* Fixed problems with AMD IRQ remapping code that came up
> 	  in testing
> 
> Changes from v2->v3:
> 
>         * Rebased to v3.6-rc7
>         * Worked in most comments on v2 by Sebastian Andrzej Siewior
> 
> Changes from v1->v2:
> 
>         * Fixed a couple of compile issues on i386 (reported by
>           Fengguang Wu, thanks a lot)
>         * Rebased to Linux v3.6-rc2
> 
> Please review.
> 
> Cheers, 
> 
>         Joerg
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
