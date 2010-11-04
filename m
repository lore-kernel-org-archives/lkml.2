Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0KDRfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:35:01 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39989 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0KDRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:34:58 -0400
Date: Thu, 4 Nov 2010 12:34:56 -0500
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Crypto API User-interface
Message-ID: <20101104173456.GA1321@gondor.apana.org.au>
References: <20100907084213.GA4610@gondor.apana.org.au> <20101019134418.GA13514@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019134418.GA13514@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 09:44:18PM +0800, Herbert Xu wrote:
> 
> OK I've gone ahead and implemented the user-space API for hashes
> and ciphers.

Here is a revised series with bug fixes and improvements.  The
main change is that hashes can now be finalised by recvmsg instead
of requiring a preceding sendmsg with no MSG_MORE.

Thakns to Miloslav Trmac for reviewing this and contributing
fixes and improvements.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
