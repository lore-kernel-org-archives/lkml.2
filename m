Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab2EOLXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:23:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:44505 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab2EOLXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="166507408"
Message-ID: <1337081204.2528.171.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] UBI: add lnum to struct ubi_work
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 14:26:44 +0300
In-Reply-To: <1337080498.2528.161.camel@sauron.fi.intel.com>
References: <alpine.DEB.2.00.1205142046080.12448@eristoteles.iwoars.net>
	 <1337080498.2528.161.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-S9BE4vQuKYeVRJsp5J43"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S9BE4vQuKYeVRJsp5J43
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 14:14 +0300, Artem Bityutskiy wrote:
> On Mon, 2012-05-14 at 20:47 +0200, Joel Reardon wrote:
> > @@ -1086,13 +1090,14 @@ out_ro:
> >   * @ubi: UBI device description object
> >   * @pnum: physical eraseblock to return
> >   * @torture: if this physical eraseblock has to be tortured
> > + * @lnum: the last used logical eraseblock number for the PEB
> >   *
> >   * This function is called to return physical eraseblock @pnum to the =
pool of
> >   * free physical eraseblocks. The @torture flag has to be set if an I/=
O error
> >   * occurred to this @pnum and it has to be tested. This function retur=
ns zero
> >   * in case of success, and a negative error code in case of failure.
> >   */
> > -int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture)
> > +int ubi_wl_put_peb(struct ubi_device *ubi, int pnum, int torture, int =
lnum)
>=20
> Joel, am sorry for nitpicking again, but could you please put the "lnum"
> argument between "ubi" and "lnum" instead? Just feels more natural.
> Otherwise the patch is OK. Thanks!

Err, but you also need volume ID, because there may be several volumes
with the same lnum.

--=20
Best Regards,
Artem Bityutskiy

--=-S9BE4vQuKYeVRJsp5J43
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPsj10AAoJECmIfjd9wqK0UooP/RYKO4H9e2Dwj5F1QVgTOCeN
c68dJ3I2A+uVzwAYBwZe1Jan7jSoX90TAXmj1rRF+XU1XVJaneafd8rfbxr3dies
WkSoiyo2He4eACGQ9rZEmU167I4j97kyrTr/F3aJZRLVgSfz0OnHXctNZU7lvwDW
DdypJn/h9L1Y+mmjtERmsptoqdrihwBsiHtxq6Z/HC6oTUhlK3m1sTj30e8pglSM
4fDsUqoxf2PJE4v9U5O0O5mT8fs3JRFT8NlrDbvtGzUO0eoL0ZvgvCx1zJN8vF+y
P1eLdUtjuKVsBnjLBwxsj7dLLEXs49Lwb7/zeK7SQieL9JMhO34zujocRyEL653R
iKo4BYY3gnFZ1sYYeh6dXosB4UR0IDtYhw2eGt1BAgV7vQcnVFLRiA1i3Cxx8+oA
tlkA9lQPZQh+1d3Q9GheIW5zdvnFEcMvwt9cqwBinkCjfU14/yDFz3Vx7tRSRbfo
6CFV6P8L3aqGKMfH/iO+dMpDK3lnCHFDpljXql4sXpWFe5l7zZArViqRgnWXiS7b
AGEz6uctdQNR4ZKsfoa+FziH4HqhGMjdsphqpp532K7+FSHgOcdze3NTENVtQPyE
+vgh3vpUhCsfDVK530JGSeNBxNbxiYsC92rr3kAqW4mHuKnHBoVZolM+n2025YTY
Vu88BzercuVFfNX9T67i
=MYi7
-----END PGP SIGNATURE-----

--=-S9BE4vQuKYeVRJsp5J43--

