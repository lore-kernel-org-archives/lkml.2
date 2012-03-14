Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2CNJbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:31:47 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:47674 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932065Ab2CNJbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:31:44 -0400
Date: Wed, 14 Mar 2012 20:31:43 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] padata fixes
Message-ID: <20120314093143.GC2847@gondor.apana.org.au>
References: <20120309061828.GI15404@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309061828.GI15404@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 07:18:28AM +0100, Steffen Klassert wrote:
> This patchset fixes two races that I found when I tested padata
> in combination with pcrypt ablkcipher algorithms (still unpublished)
> and dm-crypt. The mainline codebase seems not to trigger them, however
> we need to fix these races before I can push the pcrypt ablkcipher
> extensions.

Since these don't trigger in mainline I've applied them to cryptodev.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
