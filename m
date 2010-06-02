Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0FBHH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:07:29 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:39230 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751799Ab0FBHH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:07:28 -0400
Date: Wed, 2 Jun 2010 17:07:25 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100602070725.GA17066@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <20100601043901.GA25693@gondor.apana.org.au> <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com> <20100602051403.GA5784@gondor.apana.org.au> <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com> <20100602060702.GA6319@gondor.apana.org.au> <20100602063033.GS2184@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602063033.GS2184@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 08:30:33AM +0200, Steffen Klassert wrote:
> 
> I did that already for one of the older (remote softirq based)
> version of pcrypt. I just never pushed it out because I was focused
> on IPsec and the softirq based version I was not that usefull for
> dm-crypt. Now, that we use workqueues internally, dm-crypt could
> benefit from pcrypt too. Let me see whether I can respin the old
> ablkcipher plugin.

Thanks Steffen!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
