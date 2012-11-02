Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2KBJNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:13:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38043 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab2KBJNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:13:51 -0400
Date: Fri, 2 Nov 2012 11:07:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the usb tree
Message-ID: <20121102090743.GB17938@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121102150828.74ea49649b1601ecb5d0eaef@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <20121102150828.74ea49649b1601ecb5d0eaef@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 02, 2012 at 03:08:28PM +1100, Stephen Rothwell wrote:
> Hi Greg,
>=20
> After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
>=20
> WARNING: drivers/usb/host/ehci-hcd: 'ehci_init_driver' exported twice. Pr=
evious export was in drivers/usb/chipidea/ci_hdrc.ko
> WARNING: drivers/usb/host/ehci-hcd: 'ehci_resume' exported twice. Previou=
s export was in drivers/usb/chipidea/ci_hdrc.ko
> WARNING: drivers/usb/host/ehci-hcd: 'ehci_suspend' exported twice. Previo=
us export was in drivers/usb/chipidea/ci_hdrc.ko
> WARNING: drivers/usb/host/ehci-hcd: 'ehci_setup' exported twice. Previous=
 export was in drivers/usb/chipidea/ci_hdrc.ko
>=20
> Introduced by commit 3e0232039967 ("USB: EHCI: prepare to make ehci-hcd a
> library module").

Alex, why on earth is chipidea exporting symbols it doesn't own ?

--=20
balbi

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQk41fAAoJEIaOsuA1yqREsIcP/3bwBuIxIjRMvrRNGludhYr+
OZ/oQBp4DqMqew11bjUzu0v+xQ+xZ8FI0d63bV4ivV9a30k0n2tZWV6CkkK0unfn
r7oBTkiQd5mAeUn3IfZ8fEucbxzzCV0SOR96j+0nPnxeaF8mn3r9F+Jwm5XafEJ5
0aratm18m2FrWiP6rOZl9Cjw03V8zMLkpUZNzwihr3VXLVJw3t6dkJa7JmtYrTnZ
AlUzva/TVq4BxUChBqYZGTh5r0xag6HvAo80iSh30+dys7hpLK8BovGzXk6BqpRt
viSH069bd/T3ylsjlV1DbRw6JPyCDHfq6BOGdtQ5qX69L2U9+UYTkhrDsWC9F+/1
eYPPOSzEKeeWLEy8l7F0cIMwIttgvWw9ssvqfeC40DzTOzzbTwOMQdSFR3VB6MxH
m2dZcEXhUe7ZerWHAjpkzzOkcajqqsh14sxtmHfE3XYmk/Jpc05y288IdXoMy3FC
io/PJL2YriD0b1Lky25FGvx1w7IhIulkkiP5gHYAFqMRqzLnVaICORpSZjmYnBlU
BjWLEfpTsAgp2k2OKS89Q6CILmHLuDkCVL3u9uN33nZIyKfDTTtuwfvQZ58j3+8f
Vye3GIVdGaMqMyD8/cC66mh8WcKWZlbqYCb98vuUFqg0iBu+ekmF6UIIVlt9YaBo
zAs8BqFj4eTXxy+sz7MS
=a6Ba
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
