Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab0FCKT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:19:57 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:58425 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933671Ab0FCKTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:19:54 -0400
Date: Thu, 3 Jun 2010 20:19:37 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Dan Carpenter <error27@gmail.com>,
       Henrik Kretzschmar <henne@nachtwindheim.de>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] padata: add parenthesis in MAX_SEQ_NR macro
Message-ID: <20100603101937.GA31063@gondor.apana.org.au>
References: <20100525212913.GK22515@bicker> <20100526063227.GP2184@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526063227.GP2184@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 08:32:27AM +0200, Steffen Klassert wrote:
> On Tue, May 25, 2010 at 11:29:13PM +0200, Dan Carpenter wrote:
> > MAX_SEQ_NR is used in padata_alloc_pd() like this:
> > 
> >         pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
> > 
> > It needs parenthesis or the divide by num_cpus takes precedence over the
> > subtraction.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
