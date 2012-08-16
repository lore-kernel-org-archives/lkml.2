Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2HPG7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:59:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37911 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab2HPG7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:59:21 -0400
Date: Thu, 16 Aug 2012 16:59:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Message-Id: <20120816165912.ca770bb4464a37f1ed4fb968@canb.auug.org.au>
In-Reply-To: <CAG4TOxNLenjQxZNb7Rpm2G9RNBN77uWgEgfNXgoj+gLFdObuTg@mail.gmail.com>
References: <20120816114443.600553d2fd103a5b2b36e061@canb.auug.org.au>
	<CAG4TOxNLenjQxZNb7Rpm2G9RNBN77uWgEgfNXgoj+gLFdObuTg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Aug_2012_16_59_12_+1000_vfpAlVeFxZ6uunvS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Aug_2012_16_59_12_+1000_vfpAlVeFxZ6uunvS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

Thanks for the fix.

On Wed, 15 Aug 2012 21:07:37 -0700 Roland Dreier <roland@kernel.org> wrote:
>
> > See Rule 1 in Documentation/SubmitChecklist.
>=20
> Heh, but it compiles fine on x86!

Which is why we have Rule 1 :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Aug_2012_16_59_12_+1000_vfpAlVeFxZ6uunvS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLJpAAAoJEECxmPOUX5FE7zcP/1as1IL1Ro8XEwqPdHmev0/b
kg76jlTblQXRE08ASZAZh1UEeULmvO9v9RESU+0A78H8gv0LuhOc3pmcIXKIfob1
M3rPdJNCt/YKze00hSQMRwMIlDcs2FD2//CYPNWstrtrxu+uNrHHOnT+uBK+p5vM
ycx95undBnL5ZHGnXpVSfwD/zQEWm2NnjQmRIg9q7FW4Agso/nxSChcsrxJTGnDQ
cEQk/wy0Ny2F+3jvFXsRfis9tVMyUXz+SHfanpO7GsDBTspL8GzAKkGkxlTGdTkS
ZDVO28fuvxHHo6GmTCAz/wW6qVtCa0myeLbAnGp9Tz3ebNFYnrVHaq3LEXsxgWKo
TU61XYaA2lnbswpk0h1jkDTvIa8EME6aD2Wmb7ueG2tLNrmhu4FOUsqaupVSaFMH
7PGNb9oaNHdg4pbzEBEj8l/Cd0s/MonHlu2CsKvtGSXbeZspJmy7wfMOiChmQt+N
Z5K5LZgVAfhD5lINqJOKrkOQdZTms7cBYkZGDhYJLws9sd0VuB2u38fvY6xtbsdf
GpeRP8RE4/z4TVcoCm3SKHVKdQDU/x2Fhnq1md2QGEhGuZ1+A478IDpjQhPbev+h
PojsxvAThpWZknbZz/VJ0a8hEn9qI7Q7prDqPI6owANI73mqPMACg98GtZJ7EeT7
dwdlC0jC816sL5BlL+oj
=Mvzh
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Aug_2012_16_59_12_+1000_vfpAlVeFxZ6uunvS--
