Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0K0IdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 03:33:23 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34381 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0K0IdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 03:33:22 -0500
Date: Sat, 27 Nov 2010 16:33:16 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tracey Dent <tdent48227@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Crypto: Makefile: Makefile clean up
Message-ID: <20101127083316.GB2364@gondor.apana.org.au>
References: <1289069448-1861-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289069448-1861-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 02:50:48PM -0400, Tracey Dent wrote:
> Changed Makefile to use <modules>-y instead of <modules>-objs.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
