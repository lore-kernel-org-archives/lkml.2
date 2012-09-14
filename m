Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2INN5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:57:24 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:5614 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2INN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:57:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344211200"; 
   d="scan'208";a="14548192"
Date: Fri, 14 Sep 2012 14:56:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH v4 00/24] Introduce Xen support on ARM (based on
 3.6-rc5)
In-Reply-To: <20120914132108.GQ25249@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1209141455350.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <20120914132108.GQ25249@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012, Konrad Rzeszutek Wilk wrote:
> I already put in these
> 
> 1)      xen/events: fix unmask_evtchn for PV on HVM guests
> 2)      xen: missing includes
> 3)      xen: update xen_add_to_physmap interface
> 4)      xen: Introduce xen_pfn_t for pfn and mfn types
> 5)      xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST
> 6)      xen: allow privcmd for HVM guests
> 
> in my tree as they also impact/help the PVH domains which works for
> x86 (Well, not all of them). They are in my stable/for-linus-3.7 git tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git)
> and also in #linux-next.
> 
> 
> If it would make reviewing easier, I would recommend you rebase
> your tree on top of the stable/for-linus-3.7 and just post them
> as it would make the number of patches smaller.

I have done that and it went quite smoothly. The patch series is now 5
patches smaller.
Thanks!
