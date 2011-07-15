Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab1GOPjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:39:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23008 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1GOPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:39:21 -0400
Date: Fri, 15 Jul 2011 11:37:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Subject: Re: [Xen-devel] Re: [PATCH v6] xen pci backend driver.
Message-ID: <20110715153721.GA7512@dumpdata.com>
References: <1303333640-5994-1-git-send-email-konrad.wilk@oracle.com>
 <20110425115850.48b7d254@jbarnes-desktop>
 <20110527152220.GA10031@dumpdata.com>
 <20110531100040.60ade056@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531100040.60ade056@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E205EBB.00DB:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Jesse,
> > 
> > Xen has a drivers/xen directory. In the past we have put some of the
> > "backends" in there, such as the SWIOTLB one. Perhaps some of it (or all?)
> > of this driver should go in there? If you are OK with this I can do it
> > that way and start chasing folks to review this driver?
> 
> Yeah, I'm fine with that.  Each arch typically has a chunk of PCI code
> under arch/ anyway (some more than others), so doing it that way is ok
> with me.
>  
> > > Figuring out some way to preserve the git history is probably a good
> > > idea, assuming it's not too much of a mess.  If it is, a more
> > 
> > I tried to keep it clean.. Most of the stuff is from me thought so I might
> > as well just squash it in one.
> 
> Yeah that's up to you; presumably you just want to preserve the useful
> parts of the history, or maybe just make the initial changelog big
> enough to include all the important bits you've learned over the
> years. :)

Hey Jesse,

I reposted it (fixed a bug, added a feature, and moved them to drivers/xen)
here:
https://lkml.org/lkml/2011/7/12/299

And I've coalesced the git history a bit to clump all the cleanpatch, incremental
features, etc in one big piece. Made it from 50 down to 18 patches. They are
in

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pciback-0.6.2

What are your thoughts about it?
