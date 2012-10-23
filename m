Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2JWIvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:51:53 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2749 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab2JWIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:51:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,634,1344211200"; 
   d="scan'208";a="15326913"
Message-ID: <1350982301.2237.6.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V3 1/6]: PVH: basic and header changes,
 elfnote changes, ...
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Oct 2012 09:51:41 +0100
In-Reply-To: <20121019131707.GG26830@phenom.dumpdata.com>
References: <20121017172642.349b2aae@mantra.us.oracle.com>
	 <alpine.DEB.2.02.1210181150250.2689@kaball.uk.xensource.com>
	 <20121019131707.GG26830@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 14:17 +0100, Konrad Rzeszutek Wilk wrote:
> > > +config XEN_X86_PVH
> > > +	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> > > +	depends on X86_64 && XEN && EXPERIMENTAL
> > > +	default n
> > > +	help
> > > +	   This option enables support for running as a PVH guest (PV guest
> > > +	   using hardware extensions) under a suitably capable hypervisor.
> > > +	   This option is EXPERIMENTAL because the hypervisor interfaces
> > > +	   which it uses are not yet considered stable therefore backwards and
> > > +	   forwards compatibility is not yet guaranteed.  If unsure, say N.
> > 
> > Do we really need the kconfig symbol? Why can't we have it always
> 
> Yes for right now. That is to make sure that we can test for regressions
> PV guests on a hypervisor without PVH extensions - or vice-versa:
> PVH hypervisors with an normal PV guest.

Also the "depends on X86_64" bit is currently quite important...

Ian.

