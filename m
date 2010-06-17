Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab0FQLV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:21:27 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:41325 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759878Ab0FQLVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:21:25 -0400
Date: Thu, 17 Jun 2010 21:21:19 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Subject: Re: [RFC PATCH v7 01/19] Add a new structure for skb buffer from
	external.
Message-ID: <20100617112119.GB1515@gondor.apana.org.au>
References: <1275732899-5423-1-git-send-email-xiaohui.xin@intel.com> <20100606161348.427822fb@nehalam> <20100608052744.GA21547@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D791100848F9F@shsmsx502.ccr.corp.intel.com> <20100611052112.GA25649@gondor.apana.org.au> <F2E9EB7348B8264F86B6AB8151CE2D791210AA4475@shsmsx502.ccr.corp.intel.com> <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F2E9EB7348B8264F86B6AB8151CE2D79134F9AA999@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 04:58:36PM +0800, Xin, Xiaohui wrote:
> 
> Herbert,
> In this way, I think we should create 3 functions at least in drivers to allocate rx buffer, to receive the rx buffers, and to clean the rx buffers.
> 
> We can also have another way here. We can provide a function to only substitute 
> alloc_page(), and a function to release the pages when cleaning the rx buffers.

Yes that's exactly what I had in mind.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
