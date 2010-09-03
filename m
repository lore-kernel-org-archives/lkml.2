Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0ICLKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:10:38 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:34976 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0ICLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:10:37 -0400
Date: Fri, 3 Sep 2010 19:10:31 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] padata: add missing __percpu markup in
	include/linux/padata.h
Message-ID: <20100903111031.GA31881@gondor.apana.org.au>
References: <20100811182925.GB4097@secunet.com> <1281610467-9414-1-git-send-email-namhyung@gmail.com> <20100816071309.GB2796@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816071309.GB2796@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 09:13:09AM +0200, Steffen Klassert wrote:
> On Thu, Aug 12, 2010 at 07:54:27PM +0900, Namhyung Kim wrote:
> > parallel_data->queue is a percpu pointer but was missing __percpu markup.
> > Add it.
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
