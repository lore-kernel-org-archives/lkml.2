Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2FGQcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:32:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab2FGQcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:32:47 -0400
Message-ID: <4FD0D7AA.4010506@nod.at>
Date: Thu, 07 Jun 2012 18:32:42 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Boaz Harrosh <bharrosh@panasas.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jslaby@suse.cz
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at> <4FCF6748.6020005@panasas.com> <4FD059AC.8050808@panasas.com> <4FD06A22.6040002@nod.at> <4FD07F14.50902@panasas.com> <4FD0802A.1020203@nod.at> <20120607115227.6643d1ad@pyramind.ukuu.org.uk> <4FD0C64D.2050302@nod.at> <20120607173711.22ae146f@bob.linux.org.uk>
In-Reply-To: <20120607173711.22ae146f@bob.linux.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig97BE448D7D535C6205EBA3FF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97BE448D7D535C6205EBA3FF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 07.06.2012 18:37, schrieb Alan Cox:
> Yes I know exactly what is going on. However getting a more tolerant
> behaviour is going to take a couple more kernels.
>=20

So, then please tell me what's the proper way to fix the UML console driv=
er?

- tty_port plus ->hangup() works only with a patched util-linux
- tty_port without ->hangup() seems to work only if *getty does not call =
vhangup()

Thanks,
//richard



--------------enig97BE448D7D535C6205EBA3FF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP0NerAAoJEN9758yqZn9eLTgH/iBOMASvpr6Ix0d+WhQHB2ZL
Irk+5FI5jT3YnKK5XS1UmfTEpo9gmf2dO5xU6Y+dOB9N6P7DEcuub07iM/gkrdGd
KL/K7Vr9bEXzNE8hfKQ4oHvqcAx57DmtAcXssWlO8pWNZN06JMDToJbSdcDDsGdv
+5tSJ2H/4v3edlmuA/FIELMd3Ga7nx7u7NM0ySBgdEM3vP1UiSHrRTQ9uZT+pSnX
qcShH+yHIhn/D1IeqJGtIsJU49navbkixcHsQKKc+7ar0SbQ9p38lpqSBOxtUEon
jtkU/NhsLzHCp6NUXFXmFlobi5FMoL8TvKU6W15b6pxQRjpNfZvS7GiS2xZBQKg=
=pXWa
-----END PGP SIGNATURE-----

--------------enig97BE448D7D535C6205EBA3FF--
