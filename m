Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1GYAmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 20:42:15 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:49409 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1GYAmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 20:42:13 -0400
Date: Mon, 25 Jul 2011 08:42:00 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] skbuff: clear tx zero-copy flag
Message-ID: <20110725004200.GA25794@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310195566.25391.6.camel@localhost.localdomain>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shirley Ma <mashirle@us.ibm.com> wrote:
> 
> This patch clears tx zero-copy flag as needed.
> 
> Sign-off-by: Shirley Ma <xma@us.ibm.com>

I think we also need to copy and clear this flag on the splice
read path as that takes a direct page reference.

I hope there isn't any other path that does this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
