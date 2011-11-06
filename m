Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1KFWip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:38:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39921 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1KFWio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:38:44 -0500
Date: Mon, 7 Nov 2011 01:39:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH v2] staging/xgifb: Convert pci_table entries to
 PCI_DEVICE (if PCI_ANY_ID is used)
Message-ID: <20111106223915.GT4682@mwanda>
References: <1320613517-3086-1-git-send-email-peterhuewe@gmx.de>
 <1320617548-9506-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jZNlLGxhPb4urluq"
Content-Disposition: inline
In-Reply-To: <1320617548-9506-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EB70C65.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jZNlLGxhPb4urluq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 06, 2011 at 11:12:28PM +0100, Peter Huewe wrote:
> This patch converts pci_table entries to use the PCI_DEVICE macro,
> if .subvendor and .subdevice are set to PCI_ANY_ID,
> and thus improves readability.
>=20
> v2:
> Since the driver_data field isn't used anywhere we can also drop the
> assignments for class, class_mask and driver_data.
> (found by Aaro Koskinen)
>=20
> KernelVersion: Staging-20111106

Don't put that into the permanent changelog.

Sometimes we ask people what tree they wrote a patch against, but the
truth is that we don't actually care.

Q: Your patch doesn't apply.  Which tree did you do it against?
A: Blah blah blah long explanation.
Q: Oh that's very nice and lovely.  Please redo it against today's
   -next tree.

For bug fixes where it could go into either the current kernel or the
next, then it is nice to say.  Normally people want a [patch -next
v2] in the subject which will get removed by git am.  Or below the
--- dashes.

regards,
dan carpenter


--jZNlLGxhPb4urluq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOtwySAAoJEOnZkXI/YHqRWj0P/iu+GgempIr68ooWHGuGwG6n
YOsI5QNiRtn1/GDHTptVG4Ssuaw1cqYN9OXfE/dpsO138R4bJgKAR9jAnFjr1opF
3wR/e1z+o+rGqeGq46+tyH1E6Rk3bixoOKQXz9Q22Ist9lVvZwauAxzYSv68QIxT
jece8OXRsX8EhjYIoqCKswp5i3RU8B9qg79hSI+ly7fYb/JtytKgl+uUwAfCSNhs
cZujfH5ywGo58FaX7YzcnfyN+0AiqpkOYisguo00CxHpYAJVMrtm0KkGT677ztz4
oafKL/7HDPxogm6QtxMry9lXB9XiV4zALvC1Ae0o6gbfiQqGvPJHfQhXYyLGbUnr
VUIH9Nowr1GKHpOJXxV+P1puksvdBqxP2kp7fZlYSzUq8g4tz3/TLfTWIq6EZMAH
cZs8EF6ADwYPG2WWamZebA9O5Zz1XfpNSQxnraoV2LFK6+hpFGqIzkqM/9p/gLsc
koSdT7f196PfugX5+RQupRVcvjhwpKQV5Y6BxjC3mwZckT1pgnH6B3nMuyIWTVl8
54gcxNYktkrYsI/sZNMFXjqcAwi0ml+QHZGBAFwGBMrDnH/F5pSUTzkUbbo5QvhL
D0hzx2NQMy6x8zfAllYIIILwJVBKtpWt78Bq4n4MoF6IknsX5ySukksRyIR47bN7
pKHLDhQV9M4s7Uoou9yx
=O6Ds
-----END PGP SIGNATURE-----

--jZNlLGxhPb4urluq--
