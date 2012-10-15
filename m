Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2JOMkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:40:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33024 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab2JOMko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:40:44 -0400
Date: Mon, 15 Oct 2012 15:35:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <sshtylyov@mvista.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] usb: dwc3-omap: add dt support
Message-ID: <20121015123508.GP24333@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349688236-22814-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NwG7NuG0/W8LcLh"
Content-Disposition: inline
In-Reply-To: <1349688236-22814-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/NwG7NuG0/W8LcLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 08, 2012 at 02:53:49PM +0530, Kishon Vijay Abraham I wrote:
> This patch series adds dt support to dwc3 core and fixes few minor
> stuff in dwc3-omap glue to get dwc3 working.
>=20
> While at that it also uses *of_platform* to create the child device
> (dwc3-core) and fixes to use runtime API's to enable clock and write
> to SYSCONFIG register.
>=20
> Changes from v2:
> * Fixed Sergei comment to use of_property_read_u32 insted of of_get_prope=
rty
>=20
> Changes from v1:
> * made device_for_each_child() as a seperate patch
> * made all other minor fixes wrt typos and function renames
>=20
> This patch series is developed on:
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git dwc3

will any of the DT folks review this or should I take it as is ? I'd
like to keep this in linux-next for a long time for v3.8 merge window.

cheers

> Kishon Vijay Abraham I (7):
>   usb: dwc3-omap: use device_for_each_child to handle child removal
>   usb: dwc3-omap: use of_platform API to create dwc3 core pdev
>   usb: dwc3-omap: use runtime API's to enable clocks
>   usb: dwc3-omap: Remove explicit writes to SYSCONFIG register
>   usb: dwc3-omap: Add an API to write to dwc mailbox
>   usb: dwc3-omap: Minor fixes to get dt working
>   usb: dwc3: core: add dt support for dwc3 core
>=20
>  Documentation/devicetree/bindings/usb/dwc3.txt |   23 ++++
>  drivers/usb/dwc3/core.c                        |   14 +-
>  drivers/usb/dwc3/dwc3-omap.c                   |  173 +++++++++++++-----=
------
>  include/linux/usb/dwc3-omap.h                  |   30 ++++
>  4 files changed, 160 insertions(+), 80 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt
>  create mode 100644 include/linux/usb/dwc3-omap.h
>=20
> --=20
> 1.7.9.5
>=20

--=20
balbi

--/NwG7NuG0/W8LcLh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfAL8AAoJEIaOsuA1yqREKPcQAKfi+shauNPvlbx3aNWcRxPc
Xll49Fz4c5JHyLJXE/RIJaCz/V/vQR+vsju13VQZwi/WM/uBTAas4m9WTR7pk6nF
1F/CQnfIlv/fjk86eMZ6aPat6wcTspfK4ZdgewTEcgPwrgChmRuDzZ3JLyIv6c54
pDSXMhHhCkZy8P+gWIB3IS6YW+5+mN8KEvuylZJwPIBtr4drAxQzOJHIGzewI4JW
SDdI3S8hiSjdq5nvze0bAoPrSQ5Zf9xvPMtdBaN4rreGdgiEqwa1goSPc5sVUXSC
ICCS9XJNw8nwAlcOP1AbFzhKtECow3kaae8ifKKLIdTgGaUxL0RVe7f8k8PZohY2
PqExNdqwFp4sX7RlnNzSbG4uLHvR826WuydmE4Di3vYm4Hzsqd/YAEhNSh97Labi
0Ctr4P6Axl852gnsbL9lM3dDvQSpMPgIPXbK1wr8RnPWqj8ny7RGl+RiKXKnK+UG
h/a5aYR9wfJWZBAUfe7ELxdWPqURVYWudta0o9JZn9a5nbrsgj1gz8rkFb2YMS4D
rD0EHIsDY5BEQNiGYFrR0/277DKTVWSpUYmRuRzFYLeFCtOa395KO2TFyv4tXyMn
L9YnvxHDIjuvzy1sG3i2EDrznHLthLaz8fQlp1nbAcCy38vzpn0pJfqnrD+IAjKc
AiLFZkgGQBT/y2SRvrtP
=zb/u
-----END PGP SIGNATURE-----

--/NwG7NuG0/W8LcLh--
