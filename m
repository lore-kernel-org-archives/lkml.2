Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab1DZDFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:05:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28464 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1DZDFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:05:53 -0400
Date: Mon, 25 Apr 2011 23:05:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Subject: Re: [Xen-devel] Re: [PATCH v6] xen pci backend driver.
Message-ID: <20110426030540.GA29384@dumpdata.com>
References: <1303333640-5994-1-git-send-email-konrad.wilk@oracle.com>
 <20110425115850.48b7d254@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425115850.48b7d254@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DB6368E.0025:SCFMA922111,ss=1,fgs=0
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

4K lines of code is a lot :-) Thank you for taking a look at it.

> 
> But maybe the back end belongs in arch/x86/xen as it's really a arch
> specific PCI implementation at heart?  I don't want to be a bottleneck
> for any Xen specific PCI patches in the future, and other arches have a
> similar split (though not always with an ideal core vs arch split).

I was thinking about having it in the drivers/* as ideally it should
be a module. You really don't need to have it built in. I am not that
worried about you being a bottleneck - I am OK asking two weeks before
a merge for you to pull from my tree if I have some patches for it?

Or is there some other bottleneck that I am not aware of?
> 
> Figuring out some way to preserve the git history is probably a good
> idea, assuming it's not too much of a mess.  If it is, a more
> reasonable split and history using rebase could probably be contrived
> before merging it.

<nods>
> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
