Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab0JFSsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:48:30 -0400
Received: from www.tglx.de ([62.245.132.106]:52904 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0JFSs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:48:29 -0400
Date: Wed, 6 Oct 2010 20:48:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/7] acpi: use indirect call to register gsi in different
 modes
In-Reply-To: <4CACB257.7060705@zytor.com>
Message-ID: <alpine.LFD.2.00.1010062047340.17015@localhost6.localdomain6>
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop> <1283167276-7364-4-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.00.1010061749110.2440@kaball-desktop> <4CACB257.7060705@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Oct 2010, H. Peter Anvin wrote:

> On 10/06/2010 10:00 AM, Stefano Stabellini wrote:
> > Peter,
> > I sent this patch a while back as part of the "PV on HVM: receive
> > interrupts as xen events" series (that it is based upon Konrad's
> > pcifront series, he sent another version to the list yesterday).
> > 
> > Do you think that this is a reasonble approach?
> > 
> > If you want to give a look at the whole series you can find it here:
> > 
> > http://lkml.org/lkml/2010/8/30/170
> > 
> > everything else is Xen specific stuff.
> > 
> > Thanks in advance,
> > 
> 
> On the surface it seems reasonable.
> 
> Thomas Gleixner has been working on greatly revamping a bunch of the x86
> interrupt code, and this might interact with his stuff, so it would be
> good if he could comment on it.
> 
> [tglx: what they're apparently working on is to redirect APIC interrupts
> to Xen event channels so they don't have to interact with the simulated
> memory-mapped APIC.  It's "paravirtualization light".]

I'm not touching acpi code. So that should be ok.

Thanks,

	tglx
