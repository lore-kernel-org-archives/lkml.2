Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2GBTXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:23:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:57024 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2GBTXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:23:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="163232994"
Message-ID: <1341257012.1987.2.camel@jtkirshe-mobl>
Subject: Re: [PATCH v2 0/2] Part 1: handle addr_assign_type for random
 addresses
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: shuah.khan@hp.com
Cc: Danny Kukawka <danny.kukawka@bisect.de>,
        "David S. Miller" <davem@davemloft.net>,
        Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 12:23:32 -0700
In-Reply-To: <1341255355.2750.23.camel@lorien2>
References: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
	 <1328818164.3639.15.camel@jtkirshe-mobl> <1341255355.2750.23.camel@lorien2>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-h+bkIv7LmP5Hq7QsdV/3"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h+bkIv7LmP5Hq7QsdV/3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-02 at 12:55 -0600, Shuah Khan wrote:
> On Thu, 2012-02-09 at 12:09 -0800, Jeff Kirsher wrote:
>=20
> >=20
> > Thanks Danny, I will add both patches to my queue so that we can
> > validate the changes for ixgbevf and igbvf.
>=20
> Jeff,
>=20
> Which upstream kernel did this patch end up in? Also did it make it into
> any of the stable releases?
>=20
> Thanks,
> -- Shuah
>=20

It looks like it was accepted into kernel 3.3.  I am not aware of any
stable kernels earlier than 3.3 that picked up the patch.

--=-h+bkIv7LmP5Hq7QsdV/3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJP8fU0AAoJEOVv75VaS+3OwDoP/0FEP18HiKfht7IwkReesmc1
4kmMjrPQesbdK/bfjVko+sVQEaIGmpJEhf424gqPRbGQWNmYBSmwOUS29PWsG351
jzbJA1iFUC/FX5QcM4foJCrONC9ztsIbXJtZ9NysEUMrScpFoabkjm2wgtQzHcHZ
x8X1m6f0IdTGFArgTU+oiVTUVMIwTH1BhQnKPDtJtymTn9l5DYm5iyGNV0W1pE56
0WyFN7YAJ94ql8vxjepxzvkDOvB/Z40cDuecPl6sWEUIRUau6zu4fuwSApeI+qNX
SMB3CS1oWbuvmjcOiAp2uMHldP9vmjBnAfU682NM4ZGSezjCD6sgsBjCH5Yk9JMZ
qG1NDOMobCDzMaiB8nwlOQpNqtBjT699nLqxaAqdRusVsR0hpa9sW/9rizjGxd9g
nMyj1JKK/wpU8nxcF8+WkdTD7srT8L7Tjzkbgur8cuNQdykq8aTtlnrgH1lh0mgz
5S8AjpXl4BxRi5mD0E6iNgrEZt6nfOD409i1f7QiejR4wsWrN5ykfX99+B8LzQKT
tWjHHeRZ/u+udXLohBngegbtAVo8ceCky07O8virwrfGOuzW0bi2ho5VLdFsXZhT
DgwOMKSRu1VDpnzoz/EyquuQYgzLI+R+bb5REYmI1yqz/S018eyCY1EoDYb+OVpD
ECp+P99zG3ga/3kuhFMf
=Mfp3
-----END PGP SIGNATURE-----

--=-h+bkIv7LmP5Hq7QsdV/3--

