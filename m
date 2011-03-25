Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1CYNKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:10:41 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:40339 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1CYNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:10:37 -0400
Date: Fri, 25 Mar 2011 21:10:32 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Struk, Tadeusz" <tadeusz.struk@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Subject: Re: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets
	that are not multiple of 64bytes
Message-ID: <20110325131032.GA12520@gondor.apana.org.au>
References: <4d77a344.ufBJ2BimO/o2UpKI%tadeusz.struk@intel.com> <20110313085636.GB12392@gondor.apana.org.au> <24483BA4C9F69C43A7379639D35543D7CEB6A9CE@irsmsx502.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24483BA4C9F69C43A7379639D35543D7CEB6A9CE@irsmsx502.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 09:40:28AM +0000, Struk, Tadeusz wrote:
> Hi Herbert,
> This is rather critical as packets of size different than multiple of 64bytes are dropped.
> Do you mind if we push it against stable 2.6.38?

Let me push it to 2.6.39 first :)

I'll push it to stable after that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
