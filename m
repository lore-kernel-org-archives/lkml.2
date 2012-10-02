Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2JBQzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:55:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28227 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2JBQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:55:15 -0400
Date: Tue, 2 Oct 2012 12:43:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: Re: [PATCH v2] xen/Makefile: resolve merge conflict with 9fa5780beea1
Message-ID: <20121002164333.GA28626@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1210021737000.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210021737000.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 05:45:17PM +0100, Stefano Stabellini wrote:
> This patch is actually a merge conflict resolution between Konrad's Xen
> tree and the following commit:
> 
> commit 9fa5780beea1274d498a224822397100022da7d4
> Author: Jan Beulich <JBeulich@suse.com>
> Date:   Tue Sep 18 12:23:02 2012 +0100
> 
>     USB EHCI/Xen: propagate controller reset information to hypervisor
> 
> 
> Compile dbgp.o only if CONFIG_USB_SUPPORT is defined.
> After all xen_dbgp_op relies on hcd_to_bus.
> 
> This patch should be applied on top of 
> 
> http://marc.info/?l=linux-kernel&m=134919011231980&w=2

OK. I have that in my tree (along with the other patch you posted)

so I think we are all set for this issue.
