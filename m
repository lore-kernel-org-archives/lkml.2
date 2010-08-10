Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0HJPbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:31:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62810 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab0HJPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a48MzS2MIPIGHMciTaMC+1pln8b8ozPLHzsbeJegXrOosa77nrlhuhkS6B6rW+4wyR
         VlBkNFg2SupkT+D01zbnFk4hRU1vNujoeoJkvJjh7Jy0fzjT6mUE4Tu4InbDUy0aUMPX
         gyFwkvJIevJ74Nlf6x2hRzd1T974I93Gx9QiA=
Date: Tue, 10 Aug 2010 18:35:38 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-acpi@vger.kernel.org
Subject: Re: BUG: scheduling while atomic: swapper/0/0x10000002
Message-ID: <20100810153538.GB5466@swordfish.minsk.epam.com>
References: <20100810142951.GA7156@arch.tripp.de>
 <4C616DF9.1070309@example.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <4C616DF9.1070309@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/10/10 17:19), Piotr Hosowicz wrote:
> None of them works for me. I do:
>=20
> cat patch.txt | patch -p1
>=20
> And get:
>=20
> aapi205:/usr/src/linux# cat ../smp-bug.txt | patch -p1
> patching file include/acpi/platform/aclinux.h
> Hunk #1 FAILED at 152.
> 1 out of 1 hunk FAILED -- saving rejects to file
> include/acpi/platform/aclinux.h.rej
>=20
> Help me please.
>=20

Can we see your:
include/acpi/platform/aclinux.h(.rej)

?

(did you `git pull`?)


	Sergey

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxhccoACgkQfKHnntdSXjQ3twP/Y1d+NREvt0x0zZA0JJsZ5B/V
P37MRvxW7H5hBhGulPrS3VY6mvFc4h4XkIfyLNmVDT5DDhFLkixtcOssKuVhNF80
NtTCfqJ358kUNmoBS6UsdPtgCcRWQXK0eb/7JHxK6LP3GNFoTKdtJhIUHDVV2Xbc
Z4RzArahZR9zncFkysM=
=bFdp
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
