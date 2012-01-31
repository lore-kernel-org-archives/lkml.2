Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2AaLUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:20:44 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:44737 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2AaLUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:20:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAE/NJ09bdWOb/2dsb2JhbABDr2SBcgEBBAEnLyMQCxguFCUDIROHfAO5AYs8BgEwFAOCdgIBCwIeAgR3BIJ2YwSVH5JW
X-IronPort-AV: E=Sophos;i="4.71,595,1320620400"; 
   d="asc'?scan'208";a="868879679"
Date: Tue, 31 Jan 2012 12:19:52 +0100
From: =?iso-8859-1?Q?V=EDctor_M=2E_J=E1quez_L=2E?= <vjaquez@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] staging: tidspbridge: silence the compiler
Message-ID: <20120131111952.GB19973@lit.local.igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
 <d25cfe1b88f2b749cb31887d551a1c9b0fcde42e.1327964066.git.vjaquez@igalia.com>
 <20120131080543.GA3294@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20120131080543.GA3294@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 31, 2012 at 11:05:43AM +0300, Dan Carpenter wrote:
> On Tue, Jan 31, 2012 at 12:12:20AM +0100, V=EDctor Manuel J=E1quez Leal w=
rote:
> > Silence the warning when compiling drv_interface.c
> >=20
> > Signed-off-by: V=EDctor Manuel J=E1quez Leal <vjaquez@igalia.com>
>=20
> What does the compiler warn about here?  Normally you would cut and
> paste the warning into the commit message.  But at least give us a
> hint.
>=20
> You could also reformat that printk so the message is on one line.
>=20
> 	dev_dbg(bridge,
> 	        "%s: vm filp %p offset %x start %lx end %lx page_prot %ulx flags=
 %lx\n",
> 		__func__, filp, offset, vma->vm_start, vma->vm_end,
> 		vma->vm_page_prot, vma->vm_flags);

Ok. I'll do it.

I have a doubt about the process in this case: if this is the only
modification request, should I resend all the patch set, or just this one?

Thanks

vmjl

>=20
> regards,
> dan carpenter
>=20
>=20



--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8nzlgACgkQUOuBUQZqwFIdHgCaA3zHuAfqmX9QG01t2UY/k0LN
WlEAnjx8bPEoAJeMxvtc39e6FYvJJEhU
=ieHk
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
