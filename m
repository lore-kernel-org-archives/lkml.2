Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2BJTk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:40:59 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:43223 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759958Ab2BJTk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:40:56 -0500
Date: Fri, 10 Feb 2012 11:40:45 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Scott Murray <scott@spiteful.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/16] cpcihp: fix debug module parameter to be bool
Message-ID: <20120210114045.08a2d313@jbarnes-desktop>
In-Reply-To: <1327960820-11867-7-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
	<1327960820-11867-7-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6hjhN3Y_sVpvC31tPMYTa5q"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6hjhN3Y_sVpvC31tPMYTa5q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2012 23:00:10 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> Fix debug variable from module parameter to be really bool to
> fix 'warning: return from incompatible pointer type'.
>=20
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/pci/hotplug/cpcihp_generic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/c=
pcihp_generic.c
> index fb3f846..81af764 100644
> --- a/drivers/pci/hotplug/cpcihp_generic.c
> +++ b/drivers/pci/hotplug/cpcihp_generic.c
> @@ -62,7 +62,7 @@
>  #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_=
NAME , ## arg)
> =20
>  /* local variables */
> -static int debug;
> +static bool debug;
>  static char *bridge;
>  static u8 bridge_busnr;
>  static u8 bridge_slot;

Applied to my -next branch, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/6hjhN3Y_sVpvC31tPMYTa5q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPNXK9AAoJEIEoDkX4Qk9hj08QAJUJzT3ENcJrI5ZN/N+XpQFi
uOzllqJJffnN2DA/i3dMV7EtSdPAVtMRa38V2He09fAvNjbGF3gq8iw3+Q9I8h57
tmQq/KkIKoJJERo36LC5YDeykLl4fPmW7pWe1vPyCpGBvxcDbN4lsmhVb/enkLoD
nV09PlYL1e6/Ve/9biP5uSQb74HaWIS669/APrK7xRDSVJ15O/QkxKWPv0flJEkz
voOrPKZLGM5ZGM3AdL9/lrsU0nCDilBFjUdj3LcZ5u/4DKyrLUzJdhgpn5+3CiJM
yhC9zD29UFMWmycn0F2wiO4FLe1k9cplzd0Xve+bCmRTlrFlTzykzQNejnMcUJiV
EGDuv7fg3sar3k6/qE7rwQ3oqUF9LviawT9fLJnkHbcTHtofMwMALmeErxf0fKYC
y2i5v1uAw5TDpBLEls3zLjtBdFH2qqEAq1GC+aodtB9KepFFe/VunO46GL3ssQ0e
HKnvVFmYa/Jgq91Fxn+iSuKVWIniFHJbni4tbjShsEd/aoa24UoDwRMbthezYsC5
XVA1ONaVhNso6Vcom49f/GDS0Zhc6EO2AyccfHJ/3WDA387euXAyk3nW51H8x6y5
gPZBYCFifU7b5bWEey4J2LRep7bZZs8BKjZpmQoBoWECrIA2P8yu/P85eHGbOf7a
lxxKSMi8JUip2zb1OJ7I
=LJfC
-----END PGP SIGNATURE-----

--Sig_/6hjhN3Y_sVpvC31tPMYTa5q--
