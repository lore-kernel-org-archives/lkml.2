Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab0JZHZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 03:25:51 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8960 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0JZHZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 03:25:50 -0400
X-IronPort-AV: E=Sophos;i="4.58,239,1286164800"; 
   d="scan'208";a="119688876"
Subject: Re: [PATCH 00/05] xen: events: cleanups after irq core
 improvements (Was: Re: [Xen-devel] Re: [tip:irq/core] x86: xen: Sanitise
 sparse_irq handling)
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <4CC60CDD.8040209@goop.org>
References: <tip-77dff1c755c3218691e95e7e38ee14323b35dbdb@git.kernel.org>
	 <4CB8EE8A.5020900@goop.org> <4CB8EF30.7060504@goop.org>
	 <6a6702dc-7dbb-47a3-a0cf-18c8a65252fe@email.android.com>
	 <1288023736.11153.40.camel@zakaz.uk.xensource.com>
	 <4CC60CDD.8040209@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Tue, 26 Oct 2010 08:25:46 +0100
Message-ID: <1288077946.10179.51.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 00:03 +0100, Jeremy Fitzhardinge wrote:
> On 10/25/2010 09:22 AM, Ian Campbell wrote:
> > I'm about to followup with an initial stab at some cleanups which are
> > made possible by these core changes, including hanging the per-irq info
> > off the handler_data.
> >
> > These patches are on top of recent Linus master tree plus Konrad's
> > swiotlb-xen tree and Stefano's PVHVM tree since the latter in particular
> > touches the same area.
> 
> This looks pretty good.  How much testing have you given it?

Not as much as I would like.

I've tested normal PV domU operation and live migration and that's about
it. I've not tested anything involving hardware interrupts (so no
passthrough, dom0, msi etc).

> Do you have a git branch I can pull?

The patches are currently based on trees in linux-next since they depend
on your, Konrad's and Stefano's trees (especially Stefano's, I think) so
I don't yet have a stable base for a branch. Once those flow through I
can produce a proper branch.

Ian.


