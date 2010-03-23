Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0CWG5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 02:57:10 -0400
Received: from ozlabs.org ([203.10.76.45]:53920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab0CWG5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 02:57:08 -0400
Subject: Re: [V2 PATCH 00/10] of: Consolidate scattered device node
 pointers in struct device
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Grant Likely <grant.likely@secretlab.ca>
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
In-Reply-To: <20100318144836.21082.93040.stgit@angua>
References: <20100318144836.21082.93040.stgit@angua>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V6FOmiM8suhP22YvlFQu"
Date: Tue, 23 Mar 2010 17:57:04 +1100
Message-ID: <1269327424.5953.12.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V6FOmiM8suhP22YvlFQu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-03-18 at 09:22 -0600, Grant Likely wrote:
> Currently, each of_device has a copy of the device tree node pointer in b=
oth
> .node, and in .dev.archdata.of_node (microblaze and powerpc) or
> .dev.archdata.prom_node (sparc).  Also, other architectures will be addin=
g
> CONFIG_OF support, and they will also need a reference to the device tree
> node pointer from struct device.

Assuming this is similar to your experimental-devicetree branch, as of
96b4b9d7 it causes a few build errors for me:

http://kisskb.ellerman.id.au/kisskb/head/2688/

Broken are 86xx/sbc8641d_defconfig, mpc83xx_defconfig,
mpc885_ads_defconfig, mpc85xx_defconfig, and pmac32_defconfig.

I haven't dug any further.

cheers

--=-V6FOmiM8suhP22YvlFQu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuoZkAACgkQdSjSd0sB4dId9ACfazgsVaXLGyHjh3bmJTAlR+Tg
QcYAn3+H90fVn8gZ3rvwDh+quQWxPO13
=YLDW
-----END PGP SIGNATURE-----

--=-V6FOmiM8suhP22YvlFQu--

