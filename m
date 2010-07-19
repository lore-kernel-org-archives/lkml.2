Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0GSHdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 03:33:17 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:40192 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab0GSHdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 03:33:04 -0400
Date: Mon, 19 Jul 2010 15:32:55 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] padata: cpumasks
Message-ID: <20100719073255.GA20403@gondor.apana.org.au>
References: <20100714142951.22817d0c@leibniz> <20100719060426.GA19696@gondor.apana.org.au> <20100719064050.GA11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719064050.GA11081@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 08:40:50AM +0200, Steffen Klassert wrote:
> On Mon, Jul 19, 2010 at 02:04:26PM +0800, Herbert Xu wrote:
> > 
> > All applied.  Thanks!
> 
> Hm, I was just about to write some comments on these patches,
> they still have some issues. For example, handling empty cpumasks
> is broken again (NULL pointer dereference in padata_replace).
> The cpu_index is zero for all cpus now, so can we leak objects
> on cpu hotplug etc. Also I'm not that happy with some of the
> API changes. I'll try to fix this up with some patches.

OK I'll take your fixes on top when you're ready.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
