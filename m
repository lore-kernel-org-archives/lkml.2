Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1FONRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:17:04 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:40041 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab1FONRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:17:03 -0400
Date: Wed, 15 Jun 2011 16:16:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: balbi@ti.com, Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.0-rc2] OMAP: ams-delta: fix broken uevent sysfs entries
Message-ID: <20110615131654.GS471@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <201106070316.41099.jkrzyszt@tis.icnet.pl>
 <201106151453.07945.jkrzyszt@tis.icnet.pl>
 <20110615130005.GM471@legolas.emea.dhcp.ti.com>
 <201106151514.11574.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHmdSDY+kY2au76U"
Content-Disposition: inline
In-Reply-To: <201106151514.11574.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHmdSDY+kY2au76U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 15, 2011 at 03:14:04PM +0200, Janusz Krzysztofik wrote:
> > > How would you like to have this corrected then?
> >=20
> > I guess removing __initdata from all platoform_device structures is
> > the way to go. We need to find another way to silent the section
> > mismatch warnings.
>=20
> OK. I'll cook a patch which removes __initdata from all listed above=20
> instead of only from board-ams-delta.

you can add my Acked-by line if you wish:

Acked-by: Felipe Balbi <balbi@ti.com>

and thanks for going through all this ;-)

--=20
balbi

--eHmdSDY+kY2au76U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+LDGAAoJEAv8Txj19kN1W4cIAJ2D5F1XqUP6mn3SJn5yezqK
O0y/6DuJbFn29UdJolrF4enSHxgBG7ayy7iUUukXZukfXat1gDRTDh28yGF7aCk/
swuGJB5wr0keZUaI6kbNz5hha0edtCgVUGs3FwNGR/kUp0yblxyLeU3dh762/C4t
KCy+oiB8zdMlnoWTLkHO5TOmssenAa7bRjy4RDzjxweAe47+uW3K4PstatK7QQF4
VYJi4zYGnepdSShGeHXqqVuK3X1roCzZotwPqTz1f5kkXXJxVHj7qMmyR01YGyDi
L6DA67qJdgzboNLYjp8pqUUJCzVcOlpaI342cAHYA/2EVv0tZVcdfkYx5xa+uSo=
=lWuL
-----END PGP SIGNATURE-----

--eHmdSDY+kY2au76U--
