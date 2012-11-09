Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab2KIINF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:13:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2KIIND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:13:03 -0500
Date: Fri, 9 Nov 2012 09:12:55 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 04/10] pwm: pwm-tiecap: Add device-tree binding
 support for APWM driver
Message-ID: <20121109081255.GC26007@avionic-0098.mockup.avionic-design.de>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-5-git-send-email-avinashphilip@ti.com>
 <20121109075219.GA22224@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
In-Reply-To: <20121109075219.GA22224@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:S30dBI6ld0Qes/AZt4x8+L1utjy+IEL2+TittkaoClN
 jY0NClEaWkBuuRZQa1Ahjwxfn4ZrsTLWjmVPkn/7sT/rSIqFyy
 Ry5oSGNtz+RGr6inGO7sO3PD4pYqJ0Yj4GOoDk6MpAKR2tki4X
 v9GKJUah8JjAn+Fs07w8BYBFgRf6iUkIssjitsQKnHhOIRRtHJ
 LlBygpcqULiej3U2kYUoJKn0YimsEEPTwISGJiDEtrKhOootHG
 Fq6CNNzQwImEBYQuQnLT6whVmirGoFN4kKucb07gx4LjZDErtS
 pbXAgcCVXWuuC3LVkEtTZAV9h4eesnB80aQFg/7y5laKEl6dCz
 1EXJK3kfFst9n2erUYduSGHN5fZYkv+cQj+rO+F4RIuGZ2wdgO
 DB84asyfbxSTLrLxLMdeGUTbuJ2YfodynKaGobbhVoThQ6clb/
 B6Adc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 08:52:19AM +0100, Thierry Reding wrote:
> On Thu, Nov 08, 2012 at 01:23:11PM +0530, Philip, Avinash wrote:
[...]
> >  static int __devinit ecap_pwm_probe(struct platform_device *pdev)
>=20
> __devinit can go away.
[...]
> >  static int __devexit ecap_pwm_remove(struct platform_device *pdev)
>=20
> No __devexit please.
[...]
> >  	.remove =3D __devexit_p(ecap_pwm_remove),
>=20
> No __devexit_p() please.

Okay, ignore these comments. The annotation were not added in this patch
so they can be removed in a separate patch. Or when Greg finally removes
all traces of them.

Thierry

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnLsHAAoJEN0jrNd/PrOhaDoP/1IecPaBxybYw3CLpAogOm+3
XG5BlgNxwDRIH9ToLIs91szu21uikmD/d5YMforrCBhMHWXSCKwOgUfFFqoP9/lI
tx8xXvczymB9tTjjU7j8zumDWxQOMbSxP3aZ0qysJSd2kqKEunocZJ8MfDGi6f+k
Krf3RcdFTjLUSvHFcwWQLG8yw59jfYFDy8hk3srUJdFwFX32fCfliBBhiq8Qg1ux
oHOSvbtAlFzHmsE5OfanTJt+L30Dq2gv95TLhC1KVw+9w5hC9qSicJ4/9BJ7ATN5
CYYz1KC5Xi1nC48fHLKdYyJLbnopSVhlNCwcshygvpdw/n/tdePl3c1hi9oMj/5V
sLPdTDnhUQlzjnev4lKFXBX5QMeGmwirzuC91LgfH37IG5Lbasv/3xvcmf9HLNpI
/+clGz5Xxg7ECQzzIH8qg4X85/csICxIfOD87cyMlSsBxlVazRsX1I75AhEFzlhn
KgfQJiw9r5sjJsFsxzkydPEMIqOxJZLxSxplF9khTnvQ8nQAOKhnmzNJ6J9VqDQP
jtDjnH5DzbcnILS1S7kNqdxtufyOvKxo+qj75ewtb+w+Y7wUYH5K1OfoPCyq8wcF
DxzjxksBBwGJqwoKOjkScgtfWJw1SFhfUun7pPorc1fdVXfXlKg9XuF5tOBVlnR3
MTfB6BrPsyVSqscdb6yV
=x33E
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
