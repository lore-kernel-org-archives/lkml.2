Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0DAAY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 20:24:59 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:46573 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755628Ab0DAAY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 20:24:58 -0400
Date: Thu, 1 Apr 2010 08:24:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>, steffen.klassert@secunet.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100401002440.GB18893@gondor.apana.org.au>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de> <20100329081550.GA22334@gondor.apana.org.au> <20100331145817.bd0a1a08.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331145817.bd0a1a08.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:58:17PM -0700, Andrew Morton wrote:
>
> (wtf?)
> 
> OK, on behalf of thousands I ask: what the heck is kernel/padata.c? 
> 
> Seems to have popped up in 2.6.34, positioned as generic kernel-wide
> code only it has been secreted away on the linux-crypto list.  Please
> don't do this.

It was posted to linux-kernel multiple times.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
