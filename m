Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab2LVNJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 08:09:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:61871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab2LVNJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 08:09:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,336,1355126400"; 
   d="asc'?scan'208";a="235561035"
Date: Sat, 22 Dec 2012 15:10:23 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org
Subject: Re: 3.8-rc1 build failure with MIPS/SPARSEMEM
Message-ID: <20121222131022.GA16364@otc-wbsnb-06>
References: <20121222122757.GB6847@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20121222122757.GB6847@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 22, 2012 at 02:27:57PM +0200, Aaro Koskinen wrote:
> Hi,
>=20
> It looks like commit 816422ad76474fed8052b6f7b905a054d082e59a
> (asm-generic, mm: pgtable: consolidate zero page helpers) broke
> MIPS/SPARSEMEM build in 3.8-rc1:

Could you try this:

http://permalink.gmane.org/gmane.linux.kernel/1410981

?
--=20
 Kirill A. Shutemov

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ1bE+AAoJEAd+omnVudOMApcP/1uIiUWCXP8Lym3KcmCKmK1j
pqU/ALq5X8t6SAcZTOMF7xroFabeSGZ5mXTWFJ26fgMY95LkddsFzcvO1zgl5BFp
OBkT4shs/M/cDvEcetOO0lBExAkKngOXQGd8ZATMIlXaIyZ03dJ3m/A0chsfRdwE
COPgc5ixTTwGEhAcMy1r6MBokO+pFc8ODlUGWNHOvgsW4/YKwjgzGZ1rT6vtv0rN
ah7cWeJ5PTD1HupHZSOh1P91pGwQbV1TWML+hEEJlbeLxFW47yx9vNkdjwoi1kvm
PSjHZOs1SeMQxpGP9icE/ZH1tnCeQoyIk8SD90xusV+5YRktPw8BTpdErLT7z03P
ebAKfQgixSMhEawHSe9wW6DMSRt5+IFTZlz0lYrHSfSVb2k0SbyN2oFepmih0q98
tBI8I63QpqlVlYrAFktURnNg794sWXNtsxJ4yaXBwrw5CfxFM3YalPHJOmPgB/QX
MiMBKkMVmFh+2P+Imf3w/oMqDJcg5vNjjoGG75LoIn1LnZELmc1IDoe+igof1Uac
sr7SkycpcSBshtggTvxvxO5EEgmZqNck+t4ixwQKbYOnge7SBNPzqZaa9XePeiyU
574fk+hUnQSjk1WpWzaKPmvuLnNibF6WMSBYMjbeg0sbdNLOpf0ZTp1bH5WLbmfO
nVYpX2z0UbR/s6MCw/vD
=FFgu
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
