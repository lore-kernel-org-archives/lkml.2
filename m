Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2JBPbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:31:09 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:34266 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2JBPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:31:06 -0400
X-IronPort-AV: E=Sophos;i="4.80,524,1344211200"; 
   d="scan'208";a="14898130"
Date: Tue, 2 Oct 2012 16:30:06 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/Makefile: resolve merge conflict with 9fa5780beea1
In-Reply-To: <506B236C020000780009F281@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1210021629440.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210021606000.29232@kaball.uk.xensource.com> <506B236C020000780009F281@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Jan Beulich wrote:
> >>> On 02.10.12 at 17:13, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > This patch is actually a merge conflict resolution between Konrad's Xen
> > tree and the following commit:
> > 
> > commit 9fa5780beea1274d498a224822397100022da7d4
> > Author: Jan Beulich <JBeulich@suse.com>
> > Date:   Tue Sep 18 12:23:02 2012 +0100
> > 
> >     USB EHCI/Xen: propagate controller reset information to hypervisor
> > 
> > 
> > Compile dbgp.o only if CONFIG_USB is defined.
> 
> Now this is wrong: USB is a tristate config option, yet dbgp.o
> must be built in. This is why I suggested to use USB_SUPPORT
> (if anything at all).

I see. You are right. I'll re-send the patch.
