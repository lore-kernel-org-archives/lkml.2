Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2HVRJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:09:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43094 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab2HVRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:09:17 -0400
Date: Wed, 22 Aug 2012 12:59:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Xen patches for Linux 3.7
Message-ID: <20120822165906.GA3354@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208221635020.15568@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 05:19:18PM +0100, Stefano Stabellini wrote:
> Hi Konrad,
> the followings are the patches that I am proposing for Linux 3.7.
> I am leaving out the bulk of the ARM patches for the moment.

applied. going to test it overnight.
> 
> 
> Stefano Stabellini (6):
>       xen/events: fix unmask_evtchn for PV on HVM guests
>       xen: missing includes
>       xen: update xen_add_to_physmap interface
>       xen: Introduce xen_pfn_t for pfn and mfn types
>       xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
>       xen: allow privcmd for HVM guests
> 
>  arch/ia64/include/asm/xen/interface.h      |    7 ++++++-
>  arch/x86/include/asm/xen/interface.h       |    7 +++++++
>  arch/x86/xen/mmu.c                         |    3 +++
>  drivers/tty/hvc/hvc_xen.c                  |    2 ++
>  drivers/xen/events.c                       |   18 +++++++++++++++---
>  drivers/xen/grant-table.c                  |    1 +
>  drivers/xen/privcmd.c                      |    4 ----
>  drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
>  include/xen/interface/grant_table.h        |    4 ++--
>  include/xen/interface/memory.h             |    9 ++++++---
>  include/xen/interface/platform.h           |    4 ++--
>  include/xen/interface/xen.h                |    7 +++----
>  include/xen/privcmd.h                      |    3 +--
>  13 files changed, 49 insertions(+), 21 deletions(-)
> 
> 
> A git branch based on v3.6-rc2 is available here:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git for_upstream_3.7
> 
> Cheers,
> 
> Stefano
