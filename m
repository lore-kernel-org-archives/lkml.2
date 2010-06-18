Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0FRHpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:45:12 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:35467 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461Ab0FRHpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:45:09 -0400
Date: Fri, 18 Jun 2010 17:45:01 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Message-ID: <20100618074500.GA12274@gondor.apana.org.au>
References: <20100606161348.427822fb@nehalam> <20100608052744.GA21547@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D791100848F9F@shsmsx502.ccr.corp.intel.com> <20100611052112.GA25649@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com> <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com> <20100617112119.GB1515@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D7915089FE4CC@shsmsx502.ccr.corp.intel.com> <20100618055929.GA11333@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D7915089FE573@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D7915089FE573@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 03:14:18PM +0800, Xin, Xiaohui wrote:
>
> Thanks for the verification. By the way, does that mean that nearly all drivers can use the 
> same napi_gro_frags() to receive buffers though currently each driver has it's own receiving 
> function?

There is no reason why the napi_gro_frags can't be used by any
driver that supports receiving data into pages.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
