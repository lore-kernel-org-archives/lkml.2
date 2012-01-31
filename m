Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2AaL2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:28:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45837 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2AaL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:28:54 -0500
Date: Tue, 31 Jan 2012 14:29:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] staging: tidspbridge: silence the compiler
Message-ID: <20120131112959.GJ3356@mwanda>
References: <cover.1327964066.git.vjaquez@igalia.com>
 <d25cfe1b88f2b749cb31887d551a1c9b0fcde42e.1327964066.git.vjaquez@igalia.com>
 <20120131080543.GA3294@mwanda>
 <20120131111952.GB19973@lit.local.igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QmoJrblcRudFCJH"
Content-Disposition: inline
In-Reply-To: <20120131111952.GB19973@lit.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F27D05A.011C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QmoJrblcRudFCJH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2012 at 12:19:52PM +0100, V=EDctor M. J=E1quez L. wrote:
> On Tue, Jan 31, 2012 at 11:05:43AM +0300, Dan Carpenter wrote:
> > On Tue, Jan 31, 2012 at 12:12:20AM +0100, V=EDctor Manuel J=E1quez Leal=
 wrote:
> > > Silence the warning when compiling drv_interface.c
> > >=20
> > > Signed-off-by: V=EDctor Manuel J=E1quez Leal <vjaquez@igalia.com>
> >=20
> > What does the compiler warn about here?  Normally you would cut and
> > paste the warning into the commit message.  But at least give us a
> > hint.
> >=20
> > You could also reformat that printk so the message is on one line.
> >=20
> > 	dev_dbg(bridge,
> > 	        "%s: vm filp %p offset %x start %lx end %lx page_prot %ulx fla=
gs %lx\n",
> > 		__func__, filp, offset, vma->vm_start, vma->vm_end,
> > 		vma->vm_page_prot, vma->vm_flags);
>=20
> Ok. I'll do it.
>=20
> I have a doubt about the process in this case: if this is the only
> modification request, should I resend all the patch set, or just this one?
>=20

If you sent just the one, and you redid the printk() then it would
make the later patches not apply.

Maybe just send the one, with a fixed changelog and leave the patch
as is.  The problems in the printk() were not introduced in this
patch so I can't really complain about that.  A couple people have
already volunteered to fix that in a later patch.

regards,
dan carpenter


--+QmoJrblcRudFCJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJ9C2AAoJEOnZkXI/YHqRRgQQAJAE5MTlW1lbqDP643ENA+30
f3wdGX3DkAobsiGZhOYM44u/n7nCUUeFSysCCLH2sBS+tZ4Ai2488k36y5tp348G
YDhB8h/wUytIVrdggc7jcFrbbRVsmDUyE9acuk6/LrAdtzn4aHvKYY0TfcoYUYQv
yylP8aIfxQ4T72j5H/JcSRxe2C64BOdCS4FjmPtxnHSfTnW1NgdYxvhYhSZ+h9Fk
/DNjFR8mvxerMB4V4WEGqSjhpil3rsfeh4kMRH1FmAXNF3hyV+71i7WP1bw5aspj
Eh7vN9yNLmd/RtUqsE7qE048EVLtGTwCA1fTShKB23WmNZvToPYztgBWUuY9SNcl
JJ8pID2fLYwjuGuCoVMrAhvMdzDANGwNxodbRx6gzVN3O9O1Dc/AHIMkJFKF1Edy
rIGZl7+/E8PS81hDdhQj2l05GPQKkkOJgqIqABvn2zhirrTauoHZa5A3FGE9uHK5
R2ANDY7OZfVKKoOx1KopYR+NUBLP1SgVtfemRUioatLx2PhVBcPkLvRnCcyUVscm
8pb1IUVt9zL1n57KZWch9aNBBNdEIZFv9ELZ+vZYpxT5/mj20cmHDVD8ZO/NzjBV
ATWEWKEzbjKsrmcaoIE1PU86EeaD/oNAgw+aiDihJYxJFYmHY6DmZP6UKO5kcNkd
tVWMWbgtI+9w7mASqzfR
=Ke5/
-----END PGP SIGNATURE-----

--+QmoJrblcRudFCJH--
