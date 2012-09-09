Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2IISyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 14:54:12 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:34473 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173Ab2IISyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 14:54:09 -0400
Date: Sun, 9 Sep 2012 11:53:58 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 3.6-rc5
Message-ID: <20120909185358.GA9782@gondor.apana.org.au>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
 <20120909155424.862635h7ncykg9s0@www.81.fi>
 <CA+55aFyM52LaD_fF+dwjF1aKKeVCpHpBVqAQeEAZLB+Mnrgsig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyM52LaD_fF+dwjF1aKKeVCpHpBVqAQeEAZLB+Mnrgsig@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 08:35:56AM -0700, Linus Torvalds wrote:
> On Sun, Sep 9, 2012 at 5:54 AM, Jussi Kivilinna
> <jussi.kivilinna@mbnet.fi> wrote:
> >
> > Does reverting e46e9a46386bca8e80a6467b5c643dc494861896 help?
> >
> > That commit added crypto selftest for authenc(hmac(sha1),cbc(aes)) in 3.6,
> > and probably made this bug visible (but not directly causing it).
> 
> So Romain said it does - where do we go from here? Revert testing it,
> or fix the authenc() case? I'd prefer the fix..

I'm working on this right now.  If we don't get anywhere in a
couple of days we can revert the test vector patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
