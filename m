Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0LCGIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:08:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58318 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab0LCGIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:08:13 -0500
Date: Fri, 3 Dec 2010 17:08:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc tree related)
Message-Id: <20101203170805.2d99f70c.sfr@canb.auug.org.au>
In-Reply-To: <1291355998.32570.417.camel@pasglop>
References: <20101203163206.72258fb8.sfr@canb.auug.org.au>
	<1291355998.32570.417.camel@pasglop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Dec_2010_17_08_05_+1100_chByI1gvvxxoZufB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Dec_2010_17_08_05_+1100_chByI1gvvxxoZufB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 03 Dec 2010 16:59:58 +1100 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> This toolchain is a bit ancient I suppose... Anton, do you reckon we
> should use .long based macros for these for the time being or just
> require a newer binutils ?

The currently documented minimum binutils is 2.12 ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Dec_2010_17_08_05_+1100_chByI1gvvxxoZufB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM+IlFAAoJEDMEi1NhKgbs49wIAIu7SaBGvGe5+9lk7QKEcIRz
hXZ1UDEMePw3eykuVD4rEinknQKo1OMAYFd3IEqcRcqBqBf8Fqm4N+IA2dlSO5Gn
jvPJnc2kst29fJhZm2Du2V5iROeD3qw9UCgii+H4bZcicQ2UQaqAsEGbeIl6TGGZ
qWI1bJoftYEMbzC4VZzB53UQtc90n/bIqAi8lGjycEIfk+MFsg024nHNeOskGahB
jGCIyogBi0Nsk/LRbo59QsibHFf9s0V1OpA9bx2foa8kkpyqkNUltgYnEaBfO/23
Oj4MKXWfwEmnGkbtvdCwDJq4xo5gBXr7TF7IcyRkloh/e6uOpl3eHSxSwJjhg00=
=CoCE
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Dec_2010_17_08_05_+1100_chByI1gvvxxoZufB--
