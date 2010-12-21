Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab0LUDW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 22:22:59 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:40243 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0LUDW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 22:22:58 -0500
Date: Tue, 21 Dec 2010 11:22:51 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Junio C Hamano <gitster@pobox.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 2.6.37
Message-ID: <20101221032251.GA22511@gondor.apana.org.au>
References: <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <AANLkTikM4vQe7dsN8JJ1QSLeeTbRpSnuoJU=e4H2YFoz@mail.gmail.com> <20101216004938.GA32662@gondor.apana.org.au> <20101216005813.GA820@gondor.apana.org.au> <7vd3owdaxz.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vd3owdaxz.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 01:56:40AM -0800, Junio C Hamano wrote:
>
> > OK it should be fixed for got now.  I suspect what has changed
> > is that git is now using my umask by default.
> 
> Sorry, do you mean I need to be aware of a regression in recent version of
> git?  From which version to which version of git did you upgrade?  
> 
> I offhand do not recall any recent change around umask area, especially
> with respect to rsync transport.

No I don't think it was your fault.  I haven't upgraded in a long
time and have only just caught up with Debian testing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
