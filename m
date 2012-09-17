Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2IQKxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:53:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:5035 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2IQKw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:52:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,434,1344211200"; 
   d="scan'208";a="14576915"
Date: Mon, 17 Sep 2012 11:52:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 08/10] xen/swiotlb: Remove functions not needed
 anymore.
In-Reply-To: <20120914170644.GC1481@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1209171150370.29232@kaball.uk.xensource.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com> <1347306367-28669-9-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1209141704330.29232@kaball.uk.xensource.com> <20120914170644.GC1481@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 14, 2012 at 05:06:16PM +0100, Stefano Stabellini wrote:
> > On Mon, 10 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > > Sparse warns us off:
> > > drivers/xen/swiotlb-xen.c:506:1: warning: symbol 'xen_swiotlb_map_sg' was not declared. Should it be static?
> > > drivers/xen/swiotlb-xen.c:534:1: warning: symbol 'xen_swiotlb_unmap_sg' was not declared. Should it be static?
> > > 
> > > and it looks like we do not need this function at all.
> > 
> > A grep seems to find them used in arch/x86/xen/pci-swiotlb-xen.c.
> > I fail to see where you removed them from pci-swiotlb-xen.c. Is it in
> > this patch series or another one?
> 
> I am not seeing them in that file. I think you found the
> other variant of it:
> 
> xen_swiotlb_map_sg_attrs

Yes, you are right.

