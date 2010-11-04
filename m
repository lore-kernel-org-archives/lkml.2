Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0KDS72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:59:28 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:57614 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0KDS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:59:27 -0400
Date: Thu, 4 Nov 2010 13:59:19 -0500
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: "David S. Miller" <davem@davemloft.net>,
        Kartikey Mahendra Bhatt <kartik_me@hotmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cast5: simplify if-statements
Message-ID: <20101104185919.GA2464@gondor.apana.org.au>
References: <20101027120324.0b12a8b8@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027120324.0b12a8b8@absol.kitzblitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 12:03:24PM +0200, Nicolas Kaiser wrote:
> I noticed that by factoring out common rounds from the
> branches of the if-statements in the encryption and
> decryption functions, the executable file size goes down
> significantly, for crypto/cast5.ko from 26688 bytes
> to 24336 bytes (amd64).

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
