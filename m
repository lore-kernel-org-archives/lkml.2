Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab1KHXbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:31:52 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:60005 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1KHXbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:31:51 -0500
Date: Tue, 8 Nov 2011 18:31:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [Revert] Re: [PATCH] mm: sync vmalloc address
 space page tables in alloc_vm_area()
Message-ID: <20111108233132.GA1230@phenom.dumpdata.com>
References: <1314877863-21977-1-git-send-email-david.vrabel@citrix.com>
 <20110901161134.GA8979@dumpdata.com>
 <4E5FED1A.1000300@goop.org>
 <20110901141754.76cef93b.akpm@linux-foundation.org>
 <4E60C067.4010600@citrix.com>
 <20110902153204.59a928c1.akpm@linux-foundation.org>
 <20110906163553.GA28971@dumpdata.com>
 <20111105133846.GA4415@phenom.dumpdata.com>
 <20111107203613.GA6546@phenom.dumpdata.com>
 <20111108150153.e3229374.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108150153.e3229374.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4EB9BBDE.00A9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And Linus picked it up.
> 
> I've no idea what's going on here.

Heh. Sorry for being so confusing. Merge windows are a bit stressful and
I sometimes end up writing run-on sentences.
> 
> > .. snip..
> > > 
> > > Also, not sure what you thought of this patch below?
> > 
> > Patch included as attachment for easier review..
> 
> The patch "xen: map foreign pages for shared rings by updating the PTEs
> directly" (whcih looks harnless enough) is not present in 3.2-rc1 or linux-next.

<nods>. That is b/c it does not have your Ack. The patch applies cleanly to
3.2-rc1 (as all the other patches that it depends on are now in 3.2-rc1).

I am humbly asking for you to:
 a) review the patch (which you did) and get an idea whether you are OK (sounds like you are)
 b) pick it up in your -mm tree.

or alternately:
 b) give an Ack on the patch so I can put it in my linux-next and push it
    for 3.2-rc1.

Thank you for you consideration!
