Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0CYNDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:03:47 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:57044 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0CYNDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:03:45 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 09:03:45 EDT
Date: Thu, 25 Mar 2010 09:00:03 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for March 24 (staging/vt66*)
Message-ID: <20100325130003.GB24056@alittletooquiet.net>
References: <20100324161746.85edc5a3.sfr@canb.auug.org.au> <4BAA6B88.2080803@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <4BAA6B88.2080803@oracle.com>
X-PGP-Key: http://www.alittletooquiet.net/media/forest.pubkey.asc
X-PGP-Fingerprint: 428A 6D9B EFEC EC9E 5E48  6B8F 44EE 1F41 076F E40C
X-PGP-Affinity: will accept encrypted message for GPG
X-Home-Page: http://www.alittletooquiet.net/
X-Accept-Language: en
Jabber-ID: forestatq@jabber.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 24, 2010 at 12:44:08PM -0700, Randy Dunlap wrote:
> On 03/23/10 22:17, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20100323:
>=20
>=20
>=20
> (.text+0x5d140): multiple definition of `hostap_set_hostapd'
> (.text+0x5ccab): multiple definition of `hostap_ioctl'
>=20
> when
> CONFIG_HOSTAP=3Dy
> and
> CONFIG_VT665[56]=3Dy
>=20
> or just both of the latter are =3Dy.

Is there any way to limit CONFIG_VT665[56] to ("n", "m")?  That would be
sufficient as a work-around, right?

Or is it preferable to rename the offending functions?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFLq15TRO4fQQdv5AwRAt5eAKCjAGPS+Sr/xma+5ot5thJsp1ASrQCfQwxD
GwMS2LvuOX/1TMFSPLbCTHY=
=G02o
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
