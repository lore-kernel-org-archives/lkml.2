Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1GEWjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:39:46 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:51515 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab1GEWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:39:43 -0400
Date: Wed, 6 Jul 2011 01:39:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 1/5] MFD: twl6040: Use resource to provide irq number
 for slaves
Message-ID: <20110705223937.GB8023@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
 <1309895376-17446-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <1309895376-17446-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 05, 2011 at 10:49:32PM +0300, Peter Ujfalusi wrote:
> Provide the irq number for slaves via resource on the
> platform device.
> The irq number configuration is done in the twl6040-core
> at probe time, so machine drivers do not need to be
> modified.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE5KpAAoJEAv8Txj19kN1NhkH/0X5nCRoyZzj6Lq1sCVp6DOT
H+eh9UWlhR8UJYe3KXEbSAhkDYDQ8gwnROQR7YQq7bEiDR4YwgkeXJQnwXQ93hMo
JD3/r5375yYSjNfCRESbuGDWsuPec555QucVK9A23QQYFJe9ic2xb0mb3a0KM9vT
Wvrnf3IWBxUSQCgehUk8knRhB2RJW+AeIrH8vdmDtq96VF/uhExl0a52eWWLjfPe
B1w/xzXdqocdB5wJb0J2G+2p9mjWCYdYEQaju91/ukEyVwDSYjWfMH/hfn2dSVY+
9GkTaEGKILXTTEjH7UHypxwUReMMvVDMqNtwZOUCHadyPeeuCbjPS7ZgFeZFuX4=
=2EA0
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
