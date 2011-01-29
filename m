Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1A2EKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 23:10:11 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:50970 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1A2EKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 23:10:10 -0500
Date: Sat, 29 Jan 2011 15:10:01 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: dave@gnu.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypt: ablkcipher: remove redundant NULL check
Message-ID: <20110129041001.GA21186@gondor.apana.org.au>
References: <1295972865.1998.9.camel@offworld> <20110125.123950.104063911.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125.123950.104063911.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:39:50PM -0800, David Miller wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> Date: Tue, 25 Jan 2011 13:27:45 -0300
> 
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
