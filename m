Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1GHU1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 16:27:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29065 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1GHU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 16:27:07 -0400
Date: Fri, 8 Jul 2011 16:26:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>,
        xen-devel@lists.xensource.com, jeremy.fitzhardinge@citrix.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [Xen-devel] Re: [PATCH] Modpost section mismatch fix (for
 platform-pci-unplug.c)
Message-ID: <20110708202628.GA25998@dumpdata.com>
References: <20110704221646.GB4490@Xye>
 <20110705141323.GG2972@dumpdata.com>
 <20110705142731.GA4463@Xye>
 <20110705144846.GA13548@dumpdata.com>
 <20110705213243.GA3647@dumpdata.com>
 <20110707154648.GA4394@Xye>
 <20110707162454.GA8164@dumpdata.com>
 <20110707194851.GB4394@Xye>
 <20110707200949.GA25216@dumpdata.com>
 <20110707210429.GD4394@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707210429.GD4394@Xye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E176806.0021:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>Also,
> >>I had sent another change (oneline) for the file
> >>arch/x86/xen/platform-pci-unplug.c for check_platform_magic, looks like that has not gone into
> >>the pull request for Linus.
> >
> >Oh, I didn't see it. Did you CC me on it? Can you bounce it to me please?
> >
> =========================
>  diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
>  index 25c52f9..ffcf261 100644
>  --- a/arch/x86/xen/platform-pci-unplug.c
>  +++ b/arch/x86/xen/platform-pci-unplug.c
>  @@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
>   #ifdef CONFIG_XEN_PVHVM
>   static int xen_emul_unplug;
> 
>  -static int __init check_platform_magic(void)
>  +static int check_platform_magic(void)
>   {
>          short magic;
>          char protocol;
>  --
> 

Yeah, that would cause an issue during suspend/resume by PVonHVM. How
we didn't trip over this I've no idea..

Anyhow, can you provide me with your Signed-off-by please and I will queue
it right up.

Stefano, you OK with this patch?
