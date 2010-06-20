Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0FTLwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 07:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0FTLwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 07:52:39 -0400
Date: Sun, 20 Jun 2010 14:47:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Message-ID: <20100620114719.GC5285@redhat.com>
References: <20100617112119.GB1515@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com> <20100618055929.GA11333@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D7915089FE573@shsmsx502.ccr.corp.intel.com> <20100620100631.GB4578@redhat.com> <20100620103235.GA31284@gondor.apana.org.au> <20100620103909.GA5285@redhat.com> <20100620110254.GA31484@gondor.apana.org.au> <20100620111124.GB5285@redhat.com> <20100620113609.GA31693@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100620113609.GA31693@gondor.apana.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 09:36:09PM +1000, Herbert Xu wrote:
> On Sun, Jun 20, 2010 at 02:11:24PM +0300, Michael S. Tsirkin wrote:
> >
> > Rather than modifying all guests, it seems much easier not to assume
> > specific buffer layout in host.  Copying network header around seems a
> > small cost.
> 
> Well sure we can debate the specifics of this implementation detail.

Let's do this then.  So far the virtio spec avoided making layout
assumptions, leaving guests lay out data as they see fit.
Isn't it possible to keep supporting this with zero copy for hardware
that can issue DMA at arbitrary addresses?

> However, the fact that virtio_net doesn't support feature renegotiation
> on live migration is not a valid reason against this.
> 
> Cheers,

-- 
MST
