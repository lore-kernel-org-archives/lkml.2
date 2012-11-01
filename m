Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762430Ab2KAWaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:30:21 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:43627 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477Ab2KAWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:30:19 -0400
Date: Thu, 1 Nov 2012 15:30:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Jan Beulich <jbeulich@suse.com>, jeremy@goop.org, x86@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        xen-devel@lists.xensource.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, xen: fix build dependency when USB_SUPPORT is not
 enabled
In-Reply-To: <20121101220520.GC18854@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1211011527541.26123@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1210312239120.31758@chino.kir.corp.google.com> <20121101124912.GA10743@localhost.localdomain> <5092D5EA020000780008EB85@nat28.tlf.novell.com> <20121101220520.GC18854@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Konrad Rzeszutek Wilk wrote:

> Oh. I missed that part - so do you think that this patch should also
> be used? Or do you think there is another way to fix this?
> 

Appears to be fixed by d99e65bda806 ("USB: fix build with XEN and 
EARLY_PRINTK_DBGP enabled but USB_SUPPORT disabled") as of this morning's 
tree which relies on CONFIG_USB, which effectively requires 
CONFIG_USB_SUPPORT that this patch provides, so feel free to drop mine.
