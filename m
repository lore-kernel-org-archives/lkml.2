Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0GENZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 09:25:51 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:55133 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab0GENZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 09:25:49 -0400
Date: Mon, 5 Jul 2010 21:25:27 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Sean MacLennan <smaclennan@pikatech.com>, Jiri Kosina <jkosina@suse.cz>,
       Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/25] n2-drv: remove casts from void*
Message-ID: <20100705132527.GA6974@gondor.apana.org.au>
References: <1277806502-30772-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277806502-30772-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 02:15:01PM +0400, Kulikov Vasiliy wrote:
> Remove unnesessary casts from void*.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Patch applied.  Thank you.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
