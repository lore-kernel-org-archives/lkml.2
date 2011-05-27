Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1E0PXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:23:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31097 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1E0PXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:23:37 -0400
Date: Fri, 27 May 2011 11:22:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Subject: Re: [Xen-devel] Re: [PATCH v6] xen pci backend driver.
Message-ID: <20110527152220.GA10031@dumpdata.com>
References: <1303333640-5994-1-git-send-email-konrad.wilk@oracle.com>
 <20110425115850.48b7d254@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425115850.48b7d254@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DDFC1B8.0060:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 11:58:50AM -0700, Jesse Barnes wrote:
> On Wed, 20 Apr 2011 17:07:19 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > The following patch implements the Xen pci backend for upstream Linux.
> > This is the host side counterpart to the frontend driver in
> > drivers/pci/xen-pcifront.c. The PV protocol is also implemented by
> > frontend drivers in other OSes too, such as the BSDs.
> > 
> > This driver has a long history as an out of tree driver but I am
> > submitting it here as a single monolithic patch to aid review. Once it
> > has been reviewed and is considered suitable for merging can we perhaps
> > consider merging the equivalent git branch which maintains much of
> > history?
> 
> It looks pretty clean at first glance (though 128k worth of patch isn't
> an ideal way to split it).
> 
> But maybe the back end belongs in arch/x86/xen as it's really a arch
> specific PCI implementation at heart?  I don't want to be a bottleneck
> for any Xen specific PCI patches in the future, and other arches have a
> similar split (though not always with an ideal core vs arch split).

Jesse,

Xen has a drivers/xen directory. In the past we have put some of the
"backends" in there, such as the SWIOTLB one. Perhaps some of it (or all?)
of this driver should go in there? If you are OK with this I can do it
that way and start chasing folks to review this driver?

> 
> Figuring out some way to preserve the git history is probably a good
> idea, assuming it's not too much of a mess.  If it is, a more

I tried to keep it clean.. Most of the stuff is from me thought so I might
as well just squash it in one.

> reasonable split and history using rebase could probably be contrived
> before merging it.
> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
