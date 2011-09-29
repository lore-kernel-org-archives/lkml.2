Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1I2KAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:00:54 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32632 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab1I2KAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:00:53 -0400
X-IronPort-AV: E=Sophos;i="4.68,460,1312156800"; 
   d="scan'208";a="8122791"
Date: Thu, 29 Sep 2011 11:00:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH v4 2/2] xen: modify kernel mappings
 corresponding to granted pages
In-Reply-To: <20110928230535.GA23001@phenom.oracle.com>
Message-ID: <alpine.DEB.2.00.1109291059540.3519@kaball-desktop>
References: <alpine.DEB.2.00.1109081944150.12963@kaball-desktop> <20110921145853.GA541@phenom.oracle.com> <alpine.DEB.2.00.1109231412220.8700@kaball-desktop> <20110923144538.GA10701@phenom.oracle.com> <alpine.DEB.2.00.1109271549030.3519@kaball-desktop>
 <20110928131229.GA10270@phenom.oracle.com> <20110928230535.GA23001@phenom.oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Konrad Rzeszutek Wilk wrote:
> > > > But aren't that 'range of virtual address' of struct pages? You
> > > > are using 'alloc_xenballooned_pages' to get those pages and that is
> > > > what the 'range of virtual adresses' is walking through.
> > > 
> > > it is not the same range of virtual addresses
> > 
> > OK, but the pte_maddr is the same, isn't it?
> 
> No it is not. It is the machine address of the PTE entry that
> points to the 'struct page' (kernel linear address), while the
> find_grant_pte's gets the machine address of the PTE entry that
> points to the user pages. Completlely different machine addresses
> of the PTEs.

Right


> Can you add a comment to the patch saying something along what
> I just said? Just in case somebody is as thick as I am when looking
> at this code/patch.

Sure


> Otherwise the patch looks fine - just fix up the SetPagePrivate,
> the PAGE_GRANT bit, and add extra comments and I am ready to stick it
> on my queue.

OK!
