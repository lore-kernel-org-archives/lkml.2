Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0CWXIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:08:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41800 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0CWXIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:08:35 -0400
Date: Wed, 24 Mar 2010 10:08:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the kgdb tree with the input tree
Message-Id: <20100324100829.5ff19581.sfr@canb.auug.org.au>
In-Reply-To: <4BA8C105.9020308@windriver.com>
References: <20100323140946.b56c1d8b.sfr@canb.auug.org.au>
	<4BA8C105.9020308@windriver.com>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Mar_2010_10_08_29_+1100_KTFd2KtNPtnYzRxC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Mar_2010_10_08_29_+1100_KTFd2KtNPtnYzRxC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Tue, 23 Mar 2010 08:24:21 -0500 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> I will drop mine for now.  Dmitry and I have differing implementations
> to solve the same sort of problem with trapping the sysrq.  I had wanted
> to test Dmitry's patch at some point soon.
>=20
> I had updated kgdb-next to include the RFC patches for the keyboard and
> kms code, but it is all removed again until we sort out which
> implementation we will roll with.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Mar_2010_10_08_29_+1100_KTFd2KtNPtnYzRxC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkupSe0ACgkQjjKRsyhoI8xHewCgiO8o7+87ngzCqQiKnQIpbja5
SSYAoKGw5jiikSM825yNIf2JoTQjm2tx
=rnYL
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Mar_2010_10_08_29_+1100_KTFd2KtNPtnYzRxC--
