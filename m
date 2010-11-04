Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0KDTEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:04:10 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:50682 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0KDTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:04:07 -0400
Date: Thu, 4 Nov 2010 14:04:05 -0500
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: tadeusz.struk@intel.com
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aidan.o.mahony@intel.com, gabriele.paoloni@intel.com,
        adrian.hoban@intel.com
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Message-ID: <20101104190405.GA2501@gondor.apana.org.au>
References: <4CC9946D.mailLH511GU0C@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC9946D.mailLH511GU0C@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 04:19:09PM +0100, tadeusz.struk@intel.com wrote:
> Hi Herbert,
>    We have reworked the assembly to use macros instead of the new aesni instructions.

Both applied.  Thanks for your efforts!

>    Do you think it is possible to get it in into 2.6.37?

Sorry, it needed to have been ready much earlier to make this
merge window.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
