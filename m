Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0FBFU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:20:58 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:59219 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751395Ab0FBFU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:20:57 -0400
Date: Wed, 2 Jun 2010 15:20:54 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100602052054.GA5918@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <4C04AB6E.1080305@linux.intel.com> <Pine.LNX.4.64.1006020110220.22695@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006020110220.22695@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:15:43AM -0400, Mikulas Patocka wrote:
>
> Almost every CPU is "very slow" so that it lags behind disk when 
> encrypting. CPUs with hardware AES may be the exception.

I would not call a platform like Nehalem the exception.

> If one CPU submits I/O for 10MB of data, your patch makes no 
> paralelization at all. Because all those 10MB will be encrypted by the 
> same CPU that submitted it.

He doesn't need to.  This is already solved by pcrypt.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
