Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab3AHK7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:59:34 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:2080 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3AHK7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:59:31 -0500
Date: Tue, 8 Jan 2013 05:59:30 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        herbert@gondor.hengli.com.au
Message-ID: <1423338194.36510.1357642769950.JavaMail.root@elliptictech.com>
In-Reply-To: <20130108085425.GU18940@secunet.com>
Subject: Re: [PATCH]  Added NIST CMAC to the CryptoAPI library
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC23 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I agree with the ^ comment ... I'll look into the "styles" issue, though ironically I would consider that a maintainers job...

I'll resend a bit later today.

Tom

----- Original Message -----
> From: "Steffen Klassert" <steffen.klassert@secunet.com>
> To: "Tom St Denis" <tstdenis@elliptictech.com>
> Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au
> Sent: Tuesday, 8 January, 2013 3:54:25 AM
> Subject: Re: [PATCH]  Added NIST CMAC to the CryptoAPI library
> 
> On Tue, Dec 11, 2012 at 02:00:10PM -0500, Tom St Denis wrote:
> > This patch adds NIST CMAC cipher based MAC as described in FIPS
> > 800-38B to
> > the CryptoAPI stack.  It also wires up the MAC to the IPsec stack
> > as per
> > RFC 4494.
> > 
> > This patch was tested against 3.7 with third party hardware IPsec.
> > 
> > Signed-off-by: Tom St Denis <tstdenis@elliptictech.com>
> > Acked-by: David S. Miller <davem@davemloft.net>
> > 
> 
> I agreed with Herbert Xu to integrate this via the ipsec-next tree.
> 
> However, it introduces the following warning:
> 
> crypto/cmac.c: In function ‘crypto_cmac_digest_setkey’:
> crypto/cmac.c:97:4: warning: suggest parentheses around arithmetic in
> operand of ‘^’ [-Wparentheses]
> 
> It also has a lot of coding style issues, run checkpatch.
> 
> Please fix it and resend.
> 
> Thanks!
> 
