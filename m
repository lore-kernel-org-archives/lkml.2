Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab1JCRuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:50:24 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:45895 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab1JCRuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:50:18 -0400
Date: Mon, 3 Oct 2011 20:50:16 +0300
From: Adrian Bunk <bunk@stusta.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111003175016.GC3072@localhost.pp.htv.fi>
References: <4E8655CD.90107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E8655CD.90107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 04:50:37PM -0700, H. Peter Anvin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi all,
> 
> Since the kernel.org status announcement last week a number of you
> have contacted me about re-establishing credentials.  In order to
> establish a proper PGP web of trust we need keys that are cross-signed
> by other developers.  As such, we ask that you follow the following
> steps:
>...
> 5. Get as many other kernel developers that you have physical access to
>    to sign your key after verifying the fingerprint.  Verifying keys
>    over the phone is OK if and only if you know them *extremely* well;
>    think "would I be willing to testify in court that the person I
>    talked to was X"?
> 
>    If you work in an office with multiple other Linux developers, it
>    would be a very good thing to organize a local key signing.  We will
>    do a key signing at Kernel Summit for the core kernel developers.
> 
>    A web site with recommendations for running a key signing:
> 
> 
> http://www.cryptnet.net/fdp/crypto/keysigning_party/en/keysigning_party.html
> 
>    $ gpg --fingerprint <key ID>
>    $ gpg --keyserver pgp.mit.edu --recv-key <their key ID>
>    $ gpg -u <your key ID> --sign-key <their key ID>
>    $ gpg --keyserver pgp.mit.edu --send-key <their key ID>
>    $ gpg --keyserver pgp.mit.edu --recv-key <your key ID>
> 
> 6. Please send me the key identifier and fingerprint to
>    <keys@zytor.com>.  This is a temporary address until the kernel.org
>    MX is ready to put back online; eventually we will probably have a
>    web form interface for this.

What are the exact technical requirements for key acceptance?

"as many other kernel developers" is quite vague, starting with the fact 
that there is not a clear definition of "kernel developer"...

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

