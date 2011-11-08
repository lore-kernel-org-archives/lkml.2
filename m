Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab1KHXB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:01:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1KHXBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:01:55 -0500
Date: Tue, 8 Nov 2011 15:01:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [Revert] Re: [PATCH] mm: sync vmalloc address
 space page tables in alloc_vm_area()
Message-Id: <20111108150153.e3229374.akpm@linux-foundation.org>
In-Reply-To: <20111107203613.GA6546@phenom.dumpdata.com>
References: <1314877863-21977-1-git-send-email-david.vrabel@citrix.com>
	<20110901161134.GA8979@dumpdata.com>
	<4E5FED1A.1000300@goop.org>
	<20110901141754.76cef93b.akpm@linux-foundation.org>
	<4E60C067.4010600@citrix.com>
	<20110902153204.59a928c1.akpm@linux-foundation.org>
	<20110906163553.GA28971@dumpdata.com>
	<20111105133846.GA4415@phenom.dumpdata.com>
	<20111107203613.GA6546@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011 15:36:13 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> > > > 
> > > > oookay, I queued this for 3.1 and tagged it for a 3.0.x backport.  I
> > > > *think* that's the outcome of this discussion, for the short-term?
> > > 
> > > <nods> Yup. Thanks!
> > 
> > Hey Andrew,
> > 
> > The long term outcome is the patchset that David worked on. I've sent
> > a GIT PULL to Linus to pick up the Xen related patches that switch over
> > the users of the right API:
> > 
> >  (xen) stable/vmalloc-3.2 for Linux 3.2-rc0
> > 
> > (https://lkml.org/lkml/2011/10/29/82)
> 
> And Linus picked it up.

I've no idea what's going on here.

> .. snip..
> > 
> > Also, not sure what you thought of this patch below?
> 
> Patch included as attachment for easier review..

The patch "xen: map foreign pages for shared rings by updating the PTEs
directly" (whcih looks harnless enough) is not present in 3.2-rc1 or linux-next.

