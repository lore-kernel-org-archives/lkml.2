Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2JLVWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:22:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32571 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2JLVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:22:11 -0400
Date: Fri, 12 Oct 2012 14:22:04 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 1/7]: PVH: basic and header changes,
 elfnote changes, ...
Message-ID: <20121012142204.47b9d780@mantra.us.oracle.com>
In-Reply-To: <1350031728.14806.45.camel@zakaz.uk.xensource.com>
References: <20121011145317.51655302@mantra.us.oracle.com>
	<1350031728.14806.45.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 09:48:48 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> > index fdce49c..9323b8c 100644
> > --- a/arch/x86/xen/Kconfig
> > +++ b/arch/x86/xen/Kconfig
> > @@ -50,3 +50,13 @@ config XEN_DEBUG_FS
> >  	  Enable statistics output and various tuning options in
> > debugfs. Enabling this option may incur a significant performance
> > overhead. 
> > +config XEN_X86_PVH
> > +	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > +	depends on X86_64 && XEN && INTEL_IOMMU && EXPERIMENTAL
> 
> OOI why does the kernel side require an INTEL_IOMMU? I can see why the
> hypervisor would need it but the guests (including dom0) can't
> actually see the underlying IOMMU, can they?

Well, the kernel requires the hypervisor to have it, but I guess
thats not what this is referring to. The tools can decide that.
I'll take it out.

