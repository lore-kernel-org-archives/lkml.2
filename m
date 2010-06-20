Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0FTLgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 07:36:23 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:55919 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751931Ab0FTLgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 07:36:21 -0400
Date: Sun, 20 Jun 2010 21:36:09 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20100620113609.GA31693@gondor.apana.org.au>
References: <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com> <20100617112119.GB1515@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com> <20100618055929.GA11333@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D7915089FE573@shsmsx502.ccr.corp.intel.com> <20100620100631.GB4578@redhat.com> <20100620103235.GA31284@gondor.apana.org.au> <20100620103909.GA5285@redhat.com> <20100620110254.GA31484@gondor.apana.org.au> <20100620111124.GB5285@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100620111124.GB5285@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 02:11:24PM +0300, Michael S. Tsirkin wrote:
>
> Rather than modifying all guests, it seems much easier not to assume
> specific buffer layout in host.  Copying network header around seems a
> small cost.

Well sure we can debate the specifics of this implementation detail.

However, the fact that virtio_net doesn't support feature renegotiation
on live migration is not a valid reason against this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
