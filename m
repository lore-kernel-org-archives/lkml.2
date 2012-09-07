Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2IGNTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:19:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2IGNTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:19:31 -0400
Date: Fri, 7 Sep 2012 15:19:26 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: twl: Move PWM driver to PWM framework
Message-ID: <20120907131926.GF29340@avionic-0098.mockup.avionic-design.de>
References: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de>
 <5044664C.5010508@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
Content-Disposition: inline
In-Reply-To: <5044664C.5010508@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+jvA6KywdGKXwWbU/c+e7TyXTFNbcR+zOomcUbUWyxD
 TPR+APf0uk9o+B7ecHiiFzcKa1rgy1jkV0zs4/W7aoz7YvzKQ4
 836PyF7yzxgVhM34CXPkqVE8ajVw+xkhD3FQ9GnmOcJypypm48
 i5OzuS4x6VMjz8TxvfhOCxKHfnKX2WPaR+Fm2MJfqs9gUtQfvf
 o4MNx7ho4LlWnwtUm/J0KciPv/15GeTf4oWeKmOBMKcABlHlba
 ehrG+TaNPciYGd5M+rKY/ioQzRtG0Ps5UlA+YCsHbslZm0NlNa
 bmFhg5RiSUhtYb3DtejGB7i1VvGGaaok0zvXHoKaENQbNKokPV
 cNREDUQ4CgJJcPNUbB6Ex7zmmbPfArjYpHoljFBXd7CJvuONYZ
 gnNiL2jcweUpashBX0+V1wy5VJpbM3M//t81MmIY3Zm0Kpm6yH
 QHJiY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 03, 2012 at 11:11:56AM +0300, Peter Ujfalusi wrote:
> Hi,
>=20
> On 09/02/2012 01:40 PM, Thierry Reding wrote:
> > Hi,
> >=20
> > This mini series replaces the twl_has_*() macros by the equivalent
> > standard IS_ENABLED() macro and moves the PWM driver to the PWM
> > framework.
> >=20
> > I'll take the second patch through the PWM tree but would like to have
> > some Acked-bys from people that know and have the hardware and can
> > verify that I haven't broken anything.
>=20
> All looks good for me but I have one comment for patch 2.

Okay. With that change to patch 2, can I add your Acked-by?

Thierry

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSfReAAoJEN0jrNd/PrOh8goQAL0C2/wH/cemFlaxLYm9WzRR
fRPfHSpPgIGRDsp6V5U3AA1mrOLcK28g1kQEg4t7/jRd9cMSQmCwWMN+Oxin+R7K
PnEHSdiUVzqGU0guw4ZwprdLFlJG7Pns4sXMLMiXAixt271VgqAS7GasR1aK/Xj5
iSB/JbgF4ytKTU9shkRqS7QM59JKuVqdN84l4PVWvKPHk9lmtaLAncY1N6RDO0SD
L8o7bMXQ0w746h1n5iV8NWl5mYewUP54UIjAb3A1SoDr2TPuNcUGYCQ96whG4+9l
DoCa8jsncuCcJbIusupS8YemtjpHxH6ioEnecf+FgBdDQKcdAcH8pkiNzTClxSDi
JcchuDfW63YV0wgrKpMW0mUp5ACAyCe0TQM2vCMgzusNjkVWfQjX2sFQTpgLSlRU
Y+AllO3sCQ2lqnrP2cEmhZG/deWm3BG549jCNiUokcj0cstfxehULfquPYPawZ+C
+Y2IsbQWlyZLk7cr3lLgg0CZ4deVTTn8kM1kCPYp1gbibKenPVzBI//GCEtxFOHU
TNqSH9tAqOgY0QKAtJ1ePrcAv128vFnkCkaeOdMmFKKzu7iYfoymqMcC1bBjlOvC
IXqksPstZv5eLLAYYCB+clNBz9KNDYlkV8n0kxlKdfur53Q+gYguHlAr1RmZ/TQY
5b8yXq/bD/Pb3OmFkY6w
=g0N1
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--
