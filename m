Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0JSRwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:52:15 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20267 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0JSRwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:52:14 -0400
X-IronPort-AV: E=Sophos;i="4.57,351,1283731200"; 
   d="scan'208";a="2419373"
Date: Tue, 19 Oct 2010 18:51:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-next@vger.kernel.org
Subject: Re: xen PV on HVM and initial domain merge in linux-next
In-Reply-To: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop>
Message-ID: <alpine.DEB.2.00.1010191847290.10348@kaball-desktop>
References: <alpine.DEB.2.00.1010191254460.2423@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to CC the LKML and linux-next...

On Tue, 19 Oct 2010, Stefano Stabellini wrote:
> Stephen,
> I have two patch series to merge in linux-next:
> 
> PV on HVM: receive interrupts as xen events
> xen: initial domain support
> 
> they have all the acked-by needed and are both stable since several
> weeks, however they depend on Konrad's xen-pcifront series and for this
> reason I waited until now to ask for a merge in linux-next.
> 
> Could you please pull:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git linux-next-initial-domain-v4
> 
> it contains both series rebased on Konrad's pcifront series merged on
> linux-next (warning: it still contains the merge commit of
> xen-pcifront-0.8.2 in linux-next).
> Let me know if you have any conflicts or if you need me to change the
> branch somehow.
> 
> Many thanks in advance,
> 
> Stefano Stabellini
> 
