Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1GVONN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:13:13 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:55888 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1GVONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:13:11 -0400
Date: Fri, 22 Jul 2011 22:12:41 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: penberg@kernel.org, chris@chris-wilson.co.uk, luke@dashjr.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, rjw@sisk.pl, ray-lk@madrabbit.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        florian@mickler.org, keithp@keithp.com
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
Message-ID: <20110722141241.GA22886@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722110806.GA29757@tugrik.mns.mnsspb.ru>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Smelkov <kirr@mns.spb.ru> wrote:
> 
>    Or would it be more fair to say that UMS is not supported anymore,
>    is broken and just remove support for it?

It's kind of ironic that the intention of the offending patch
was to avoid a UMS crash :)

Anyway I'm now using KMS (forced to due to new hardware) so I
certainly don't have any objections to reverting this patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
