Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2GKF1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:27:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2GKF1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:27:32 -0400
Date: Wed, 11 Jul 2012 07:27:19 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] PWM: add lpc32xx PWM support
Message-ID: <20120711052719.GA10344@avionic-0098.mockup.avionic-design.de>
References: <1341931090-18296-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1341931090-18296-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:l659zgIz9V2hkcLdXjPJ+Z/GcfSg3tb598l9wc1lFCW
 XCtw/y3n2DaYUeB0g3dab22Eu3C5RylgyHnwn9hYjaMB1AoOP6
 ZBa/se3BwFfSaIxEGMuhd7c2qHoa6uQCSgmi1ZisXe59CbX4kN
 oI7QKw7xVtjhaD7O4fotla8ahFT6VrprJSCcWRvjuvrcre+UVh
 FoXunXiAL8TF8rQRPYSXzyw31358G3cTA9mvvIEAo6dSgQg6XG
 iMifTrwtXLA+7MhCPovs1tQKEennt8FaMYxNLyyr9eYh+ToMi8
 7hS+CCNtfSqVfZ6K2etZFijCtiIfdpmadnJk8H02C/qUrtVfam
 6Uyqi+ddKW+LNKcgxX1q/62EuRA/MPngYEk1S3UZGrE2tiMCSS
 EN8/pGT4zEieON67PNSYxpImcnsv+Z6cIs9ywrPp+mwmKNZb0h
 A8RbO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 11:38:10AM -0300, Alexandre Pereira da Silva wrote:
> Add lpc32xx SOC PWM driver.
>=20
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
> Changes since v2:
> * Update commit message
> * Change the driver to handle the two PWM's of the SOC
> * Disable clock on removal
>=20
> Changes since v1:
> * Style fixes
> * Better error handling
> * Improved Kconfig and DT descriptions
>=20
>  .../devicetree/bindings/pwm/lpc32xx-pwm.txt        |   12 ++
>  drivers/pwm/Kconfig                                |   10 ++
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-lpc32xx.c                          |  148 ++++++++++++++=
++++++
>  4 files changed, 171 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>  create mode 100644 drivers/pwm/pwm-lpc32xx.c

Applied, thanks.

Thierry

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP/Q63AAoJEN0jrNd/PrOhRC8QAJpVGcaSWhdCdnzwhgRivSRN
PXCgz4IJjSjsk1VTxgYUzvdCLTFIBU2m9h4NG7WHmkGqoC8b51bz+cY6bwl34uNl
ZTvl/ONOj/6IJc/bFGjRUKxG831BENcg73pYJTIvZAsXTWWfIzVbZlj3pWMxPLIB
24gBOEijdPxopw2Ue7qpwwnpZlG1pgsJnqtXniudiN9Z+XMVdddl0KuCU1AfzQvS
e0T5PtASHkFAUNpU45/IB+YVlM94SDvWNO/I1slRHKW8J1RQOFFSlhfmCl6Op5i8
h9MErco5XG67g2favVnbGRxsSMHrj48rLtf0mhdQJlMLDbLWcTQ07/PHXxhUlY/G
wPteUtbyAdVaOPX+3n6M8H6xCp/F4bLVUMdTLMoHoV3aD6UuD3cjeVpiVYykU2OH
8LOVYm2DK/Xi+40JO0CZCSId+fixeaw3BBMobJyjchONXrbns5LOuSPhBXhKMxeB
8kckuMM0FoIJgNPu2DPNvuh6QbJuDIMIlEDqHAC8benyuJec44ptGIMLpJ4plHUX
DgbaaZpbwnNzTP5zRlGOj8S03tY+z5Olm5Rroy78/nGrumj9I735xUledEzbTYdw
JFFmi+o6PhBe374skXDv55LUBgTTBlC9syFVVEZKJPrhfLbujn86OQ03lO+QagtK
LUPuW2WezNDddna23Ue1
=endm
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
