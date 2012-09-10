Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2IJRbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:31:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2IJRbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:31:03 -0400
Date: Mon, 10 Sep 2012 19:30:56 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH v2 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Message-ID: <20120910173056.GA31611@avionic-0098.mockup.avionic-design.de>
References: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
 <504E0542.8020309@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <504E0542.8020309@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:j+SZqMo+4tu8auhFQAWVbVDyMzIr5zhpulQT4J4rUYl
 9b3+yNfw4j8lQc/Quejgps51f26mutUFc+5ZboaCSEQzgWR0j3
 WCkCf9WuCtYqj/8QFU/1yT70PSjkPyb2uWxK5MaIXCCI0yDIh1
 DgvszMW/Pp9CH5y13HyzG9Gf68nWe0lOdEJmPoY+s15ATT+ka+
 IFMLs1YIvhQqMDVxOin6Ig0snaB6Lg/Ay/kXz2B6lulMRV8bBu
 jnqiL9C3jXEWITfjxqdlBTzFUzFqiNTOG6HEEkKxgoCAUwOxak
 Zxg8I/V/G4MePzSMXw90K3+iCMVfyxZIF+LBe4i5h0/gtoYFP+
 KbelZmr/VjjEXuNZi298tNwelXHbMgqpAzquA5jWraKybuEhzn
 Te/Vl7SgY4HtHWELIf9QLEOUJbmHFYdGBxk5o6NblbSIhZKifg
 PYNVU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 10, 2012 at 05:20:34PM +0200, Lars-Peter Clausen wrote:
> On 09/10/2012 02:05 PM, Thierry Reding wrote:
> > Hi,
> >=20
>=20
> I think v2 looks, good. Will give it some testing later.
>=20
> > This small series fixes a build error due to a circular header
> > dependency, exports the timer API so it can be used outside of
> > the arch/mips/jz4740 tree and finally moves and converts the
> > JZ4740 PWM driver to the PWM framework.
> >=20
> > Note that I don't have any hardware to test this on, so I had to
> > rely on compile tests only. Patches 1 and 2 should probably go
> > through the MIPS tree, while I can take patch 3 through the PWM
> > tree. It touches a couple of files in arch/mips but the changes
> > are unlikely to cause conflicts.
>=20
> Patch 2 and 3 should probably go through the same tree since patch 3 depe=
nds
> on patch 2. I'd like to see them both go through the PWM tree.

That's fine with me. I'll probably need an Acked-by from Ralf just to be
safe.

> Patch 1 should go through the MIPS tree, but I still can't see why the is=
sue
> should occur nor does it happen for anybody else except for you. Instead =
of
> moving the content over to the public irq.h I'd rather like to see the
> private irq.h being renamed.

If we can solve this some other way I'm all for it. Maybe you can share
the defconfig or .config that you use so I can test under the same
conditions.

Thierry

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQTiPQAAoJEN0jrNd/PrOhiAMQALvMtvosXECK2p3pb2bfBOtw
NLKDadGL0SzXtBthxEI86edd6Px51aE7n1pmSa9p64ph1RqJXrD2/yl5E+FdmUFK
csqn76lN7p/TM9uHj7pizVENTxKaDCVJmEpZz5zgTMEOnSURw6LWhv8xr1tmlFwz
4FBpY2PQwCcqtfFN3YNU0CQycD3QxxVi46aMydflRjnfLa3TAIGsGYXQFO3XC1Ut
B18hksX5J0Lo0i5w76APoRN5HtEy3JA7uDxW3WUMVzwCUR/H+w4CQmqklYcr+WjB
QExWiexGLT5R7MF+PP2kBk6+YWbJIOO6z9CgFDmTHHxPVNpa9/yBmUHvXtrTKWdl
VwMWRIun6h+/U2lApUDqGznO3By8o1tspOT/aDqqgWn4IaFesDSIv19AifePnAbv
AfXZ8TOrGL33xK5LpbcVlarfGQz7RqXMP9XGwnckOxrd5z44mlSzOjrBV6MV95eS
DgpTSHSjQwVqVR4CGN9QkEfrgyPMMH7QPPf6mYWFeeY/OeIqyDYYMT7MM4EGBAQL
52ogcaEQQapiGv7MztTX4+haSSN/nSx3SZMedK+MdH1j+2uckYHUgSOLK5bdI2LE
inqvcRx0pFCW5Y/K6jOL/4MaWIJWR/8h6LuLXkLoi4Hth4f7iFT3gDeQm7KBSKK4
hZGXJy4zQgeglCRy3gko
=ND9B
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
