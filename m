Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2K0LZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:25:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab2K0LZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:25:03 -0500
Message-ID: <50B4A308.2090601@ti.com>
Date: Tue, 27 Nov 2012 13:24:56 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with Linus' tree
References: <20121126162233.9e7d7a036f2cc4a168cd3b6c@canb.auug.org.au>
In-Reply-To: <20121126162233.9e7d7a036f2cc4a168cd3b6c@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig9C57C015F8ADA6897F96FF02"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig9C57C015F8ADA6897F96FF02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-26 07:22, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> drivers/video/omap2/dss/dss.c between commit f65e384bec59 ("omapdss: ds=
s:
> Fix clocks on OMAP363x") from Linus' tree and commit bd81ed081887
> ("OMAPDSS: DSS: use omapdss_version") from the omap_dss2 tree.
>=20
> I fixed it up (using the omap_dss2 tree version) and can carry the fix =
as
> necessary (no action is required).

Thanks. I've now pulled the omapdss fixes that were merged in -rc7, and
resolved the conflicts.

 Tomi



--------------enig9C57C015F8ADA6897F96FF02
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQtKMIAAoJEPo9qoy8lh71aGEP/RsQSQcyu0kUeOmCT2kRgAAe
KtAZIezgofE2QvVwmPBfEaUFCUZY85Pods0Vc5OQkjSX7xKrvXDV4HUdxh+RnvoU
gzldCMMku2SQGsUhUhPVulVi0cqKFmFFe/LftyYNCVoahXdU1RMlQGTfNoGJfoZd
GijJ9RALq0AZOXWMLOnSSl176UCFZ5mEWmmtz3NolA7sI1gD6DEsC0vrk9WsxvUa
IId6eOShbiZcRoXiTl1d024xEKKlie2QD7PJlLRkD9nlJISDIPocUASw3+wYmO5v
h+sXBjqKoswR4WdAkuOK2GRxa5tUFXVSVHgqAGP4/Jyio4Iln9J8LAD1qvroh1K3
9fWnvc9icCD2Nxh7Awj8tG5RwjX8HNWe38pXvj1rZ8XR+qnf2b7Mpx96GF53io4q
si/2Y6q/fHxHwj//7fXud8/ESZcLdRGkq8aXMd3BDCa2hpLqYOXpAt86Kv0eH19O
x+PE4ti1GCMphbuyc5QUvFbqQtjlDB8X8gw10i/xg9DFgD6S0kKr+suQVBKWNsKo
bM7Rb8vbCvPsVvwMjfDf6iTvtF7ERynBRZC5hJUBOMCNqID1CVjLmsC0kRaBKeNC
LXPSlIA6P8K0C16xmyPBNaBwnr6wtgRzoJNTVslRwl0We2OmADt7A6aLfQoVl9pi
WuGMDfukABeSLVRDBbCo
=fibF
-----END PGP SIGNATURE-----

--------------enig9C57C015F8ADA6897F96FF02--
