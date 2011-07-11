Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1GKKmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:42:55 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8749 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1GKKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:42:54 -0400
X-IronPort-AV: E=Sophos;i="4.65,515,1304294400"; 
   d="scan'208";a="6714123"
Date: Mon, 11 Jul 2011 11:47:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <ijc@hellion.org.uk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [Xen-devel] Re: [PATCH] Modpost section mismatch fix (for
 platform-pci-unplug.c)
In-Reply-To: <20110708202628.GA25998@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1107111147420.12963@kaball-desktop>
References: <20110704221646.GB4490@Xye> <20110705141323.GG2972@dumpdata.com> <20110705142731.GA4463@Xye> <20110705144846.GA13548@dumpdata.com> <20110705213243.GA3647@dumpdata.com> <20110707154648.GA4394@Xye> <20110707162454.GA8164@dumpdata.com>
 <20110707194851.GB4394@Xye> <20110707200949.GA25216@dumpdata.com> <20110707210429.GD4394@Xye> <20110708202628.GA25998@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011, Konrad Rzeszutek Wilk wrote:
> > >>Also,
> > >>I had sent another change (oneline) for the file
> > >>arch/x86/xen/platform-pci-unplug.c for check_platform_magic, looks like that has not gone into
> > >>the pull request for Linus.
> > >
> > >Oh, I didn't see it. Did you CC me on it? Can you bounce it to me please?
> > >
> > =========================
> >  diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
> >  index 25c52f9..ffcf261 100644
> >  --- a/arch/x86/xen/platform-pci-unplug.c
> >  +++ b/arch/x86/xen/platform-pci-unplug.c
> >  @@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
> >   #ifdef CONFIG_XEN_PVHVM
> >   static int xen_emul_unplug;
> > 
> >  -static int __init check_platform_magic(void)
> >  +static int check_platform_magic(void)
> >   {
> >          short magic;
> >          char protocol;
> >  --
> > 
> 
> Yeah, that would cause an issue during suspend/resume by PVonHVM. How
> we didn't trip over this I've no idea..
> 
> Anyhow, can you provide me with your Signed-off-by please and I will queue
> it right up.
> 
> Stefano, you OK with this patch?
> 

It is fine by me
