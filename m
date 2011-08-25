Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HYXL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:11:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34658 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1HYXL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:11:58 -0400
Date: Fri, 26 Aug 2011 09:11:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Russell King <rmk@arm.linux.org.uk>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jon Medhurst <tixy@yxit.co.uk>
Subject: Re: linux-next: manual merge of the moduleh tree with the arm tree
Message-Id: <20110826091150.58697ca3adc9ba6dfcb357e0@canb.auug.org.au>
In-Reply-To: <4E56CF76.70201@windriver.com>
References: <20110825151748.8e41e0ded739187a1432cf0b@canb.auug.org.au>
	<4E56796F.8090703@windriver.com>
	<20110825163901.GA467@flint.arm.linux.org.uk>
	<4E56CF76.70201@windriver.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Aug_2011_09_11_50_+1000_ZZKR45edPESDTQIk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Aug_2011_09_11_50_+1000_ZZKR45edPESDTQIk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 25 Aug 2011 18:40:54 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> OK.  I was entertaining feeding some of the really obvious and simple
> parts of the moduleh branch out to the various maintainers just to
> reduce its overall size, but in the end I guess that just makes work
> for me and them -- vs. a single pull request to Linus for addition to
> v3.2-rc1.   I'll just stay the course and Stephen will have to rerere
> the merge conflict resolution for a while -- something I'm certain
> that he has automated long long ago.

Yeah, that's fine.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Aug_2011_09_11_50_+1000_ZZKR45edPESDTQIk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVta2AAoJEDMEi1NhKgbsVYAH/RRRLMOwFSzwPkqY7KY11buv
asUwuXcVzotascmDNtj1ZCD6mo6NBDvBMIaxyF7QRy9py95+O0JkadgI6vO8VFko
lzRCWeuvjIuwaIEUEtbSzSNibyr8WWrj8f3cIcxYQT63qPBAmQk6id512AL1pY3W
EaC7hEhiM9qtWSAiyXLWkudYSZFdTeXAGQDy6lh3P0qLoYpJQVskB4p1ns8aEEVf
Z+ziHtKGrREPtVpz4hhg0HWb5/ikrh5XnKWU+kyjHjL9DLrgs9nCmQgVCd7hc5O/
/N5CTJKK/EEy4hdxV0sjxRXJG2rqgWKkBHH+Cda8v7OCdMSmKCAeKQ2e9V8u+ZU=
=qkQc
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Aug_2011_09_11_50_+1000_ZZKR45edPESDTQIk--
