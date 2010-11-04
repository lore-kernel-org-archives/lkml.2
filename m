Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0KDTWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:22:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45556
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849Ab0KDTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:22:39 -0400
Date: Thu, 04 Nov 2010 12:23:03 -0700 (PDT)
Message-Id: <20101104.122303.112611302.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] crypto: af_alg - User-space interface for Crypto
 API
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1PE3jX-0000MM-MP@gondolin.me.apana.org.au>
References: <20101104173456.GA1321@gondor.apana.org.au>
	<E1PE3jX-0000MM-MP@gondolin.me.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 04 Nov 2010 12:36:19 -0500

> crypto: af_alg - User-space interface for Crypto API
> 
> This patch creates the backbone of the user-space interface for
> the Crypto API, through a new socket family AF_ALG.
> 
> Each session corresponds to one or more connections obtained from
> that socket.  The number depends on the number of inputs/outputs
> of that particular type of operation.  For most types there will
> be a s ingle connection/file descriptor that is used for both input
> and output.  AEAD is one of the few that require two inputs.
> 
> Each algorithm type will provide its own implementation that plugs
> into af_alg.  They're keyed using a string such as "skcipher" or
> "hash".
> 
> IOW this patch only contains the boring bits that is required
> to hold everything together.
> 
> Thakns to Miloslav Trmac for reviewing this and contributing
> fixes and improvements.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: David S. Miller <davem@davemloft.net>
