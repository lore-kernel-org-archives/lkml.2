Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1JCLTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 07:19:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1JCLTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 07:19:32 -0400
Date: Mon, 3 Oct 2011 13:19:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: <4E8655CD.90107@zytor.com>
Message-ID: <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz>
References: <4E8655CD.90107@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011, H. Peter Anvin wrote:

> Since the kernel.org status announcement last week a number of you
> have contacted me about re-establishing credentials.  In order to
> establish a proper PGP web of trust we need keys that are cross-signed
> by other developers.  As such, we ask that you follow the following
> steps:
> 
> 1. Make sure your systems are uncompromised.  We will address specific
>    recommended steps for that in a separate email.
> 
> 2. Create a new PGP/GPG key, and also generate a key revocation
>    certificate (but don't import it anywhere -- save it for the
>    future) for your new key.  In the near future we are considering
>    setting up an escrow service for key revocation certificates.
> 
>    I recommend using a 4096-bit RSA key.  Given how fast computers are
>    these days, there is no reason to use a shorter key.  DSA keys
>    should be considered obsolete; substantial weaknesses have been
>    found in DSA.
> 
>    $ gpg --gen-key
>    $ gpg -u <key ID> -o <key ID>.revoke --gen-revoke
> 
> 3. If you are reasonably certain that your old key has never been
>    jeopardized, sign the new key with the old key.

I have a question here. In case people are 'reasonably certain' that the 
old key has never been jeoparadized, why are they required to create a new 
key?

(if the old key would have been compromised, the attacker could as well 
generate a new key and sign it with the old key himself, so I fail to see 
any benefit of this PGP excercise).

It doesn't make too much sense to force people to live with two different 
personalities in this "PGP web of trust" world just for the sake of 
kernel.org, does it?

Thanks,

-- 
Jiri Kosina
SUSE Labs

