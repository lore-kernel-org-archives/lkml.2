Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2IQNYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:24:15 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:50707 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab2IQNYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:24:11 -0400
Date: Mon, 17 Sep 2012 16:19:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Chen Peter-B29397 <B29397@freescale.com>, "balbi@ti.com" <balbi@ti.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "marex@denx.de" <marex@denx.de>
Subject: Re: [RFC PATCH] drivers: phy: add generic PHY framework
Message-ID: <20120917131926.GA7699@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347623899-14485-1-git-send-email-kishon@ti.com>
 <F281D0F91ED19E4D8E63A7504E8A649803C82462@039-SN2MPN1-022.039d.mgd.msft.net>
 <CAAe_U6KvnXf7v47tVv4LYFUXjKQip7V_1FU6ujqcpoxu8QfMgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <CAAe_U6KvnXf7v47tVv4LYFUXjKQip7V_1FU6ujqcpoxu8QfMgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 17, 2012 at 11:19:53AM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi,
>=20
> On Mon, Sep 17, 2012 at 6:50 AM, Chen Peter-B29397 <B29397@freescale.com>=
 wrote:
> >
> >>
> >> The PHY framework provides a set of API's for the PHY drivers to
> >> create/remove a PHY and the PHY users to obtain a reference to the PHY
> >> using or without using phandle. If the PHY users has to obtain a
> >> reference to
> >> the PHY without using phandle, the platform specfic intialization code
> >> (say
> >> from board file) should have already called phy_bind with the binding
> >> information. The binding information consists of phy's device name, phy
> >> user device name and an index. The index is used when the same phy user
> >> binds to mulitple phys.
> >>
> >
> > What's an example of "the same phy user binds to multiple phys"?
>=20
> Single controller using multiple phys..

to be more specific here: any usb3 controller needs a USB2 PHY and USB3
PHY.

--=20
balbi

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQVyNeAAoJEIaOsuA1yqREBdIP/2EL70mqU8ZLI71u0ZEEm9C4
+QauV2QZZ22NGjpXIZCCNsrHAOtFeSGB/8kkJ8QWGklCP2SxUw6XDe9FbMz+uCWd
J92bFmo0zXVwFtilziksfTBeP9n3WSbHJvtGP+eN3QjD+WOXMMsk5ujaBjUj2ck+
3q3dmRINJLK+2Pz4FJFOmAGApaJZdftvgMNMT0QbFz8sAC8Mr4i7wKT2d/Rcyp0G
TMZBpRwCh6iCs0Lz64+aij98LeNPRAeHZG6n3keia77UQsm+giVX990XvSt1J1e4
CLt8eEz0EaTWPrFYs1cVPxZL8/bnFvWawf7oPXcD2Pmu5ybIGROcQMdYEokUOeYg
JkACqLsmY/0czDOChYLABHv7sQQlXhWlOzupPnpHapiFUkL7Eys1bISBkV3cAvvd
4uvTtZfA6FHTy8cN+twXUk1ardBgnSA42YI4TXmqmCzKJW4+1il0YZ8TkMKUHBya
qRxysPvIqSDPCXXFeSRdZsHApMq0Qagi4SgWCnX+vP4mrrGiGoSIKuLlvxGc6HIF
dsAmjRer41+HoksFpzD2x2ZAxxFPniLzI/OtwPvpsn3hLuipt9sy4LHO/F/zYApq
2Nbbl9CrzxuVs5zCcv/uy3XCAVQ0QBrA9gabFERFDaERpw+gN0VDpWpt00quXeL9
9aP4/41rFLyubYuHE4LU
=I1Qg
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
