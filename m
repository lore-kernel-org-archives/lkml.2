Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3AHJQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:16:24 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:38642 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab3AHJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:16:21 -0500
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 04:16:21 EST
Date: Tue, 8 Jan 2013 09:54:25 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.hengli.com.au
Subject: Re: [PATCH]  Added NIST CMAC to the CryptoAPI library
Message-ID: <20130108085425.GU18940@secunet.com>
References: <1068116509.71782.1353434081056.JavaMail.root@elliptictech.com>
 <231929285.161561.1355252410408.JavaMail.root@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <231929285.161561.1355252410408.JavaMail.root@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 08 Jan 2013 08:54:25.0726 (UTC) FILETIME=[C2B9BDE0:01CDED7D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 02:00:10PM -0500, Tom St Denis wrote:
> This patch adds NIST CMAC cipher based MAC as described in FIPS 800-38B to
> the CryptoAPI stack.  It also wires up the MAC to the IPsec stack as per
> RFC 4494.
> 
> This patch was tested against 3.7 with third party hardware IPsec.
> 
> Signed-off-by: Tom St Denis <tstdenis@elliptictech.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> 

I agreed with Herbert Xu to integrate this via the ipsec-next tree.

However, it introduces the following warning:

crypto/cmac.c: In function ‘crypto_cmac_digest_setkey’:
crypto/cmac.c:97:4: warning: suggest parentheses around arithmetic in
operand of ‘^’ [-Wparentheses]

It also has a lot of coding style issues, run checkpatch.

Please fix it and resend.

Thanks!
