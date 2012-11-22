Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab2KVV3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:29:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2KVV3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:29:46 -0500
Date: Thu, 22 Nov 2012 22:29:41 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH v3] pwm: Device tree support for PWM polarity.
Message-ID: <20121122212941.GL16716@avionic-0098.adnet.avionic-design.de>
References: <1353483644-32711-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9JSHP372f+2dzJ8X"
Content-Disposition: inline
In-Reply-To: <1353483644-32711-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:jswfbo9ANbeeVEwr86uaCs3L9DxBZDVwgwcwSJcBm9I
 xzswg6MDuEsPCYXjDdO0YgcErozoOJcb2Fxhn6OtenrWajIuSD
 P0g7T1V8CbC8OeETY/GQffaS72ERl8NpI6YKk8sRbFozoz+ebf
 SEmQcmGdTy8yqzN32o4+vGoTAVoVcxsfH0CtKaDTuHPuBEmmq5
 phx7XCBT6hGZbB27bQgX5YyPJgzRpvseLWgJ/GUZx2dRsINz8f
 IggwPPWBPh1uSsXp8GWpU+lFMZQB9VgVFfC0L+gaxD6Myb3yI+
 /z7frQZaeg09LnswH80uV0PcG/rMSsSntjmN8EZDjKoPNnAETk
 sdQv0Iqq3B8/tcuqGZim3TfjPY+BrzW2/VAPo7FrD2XRTVRfri
 TWWlu0ZI2peg0G6MUJQr5dhadsBO1/Kacv9iYZI2vKfNbSGwts
 ZD/+X
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 01:10:44PM +0530, Philip, Avinash wrote:
> Add support for encoding PWM properties in bit encoded form with
> of_pwm_xlate_with_flags() function support. Platforms require platform
> specific PWM properties has to populate in 3rd cell of the pwm-specifier
> and PWM driver should also set .of_xlate support with this function.
> Currently PWM property polarity encoded in bit position 0 of the third
> cell in pwm-specifier.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>

Applied with two minor stylistic cleanups, thanks.

Thierry

--9JSHP372f+2dzJ8X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrplFAAoJEN0jrNd/PrOhaTgP/iAnnHegKeb2v0YdYpEA4an/
zfxRMvbrDpkuZzx2G08WRL/nNdx6kl0nO/iKV/20X7dFoueedb/cr1ZFHj6V0sQj
ArT1EmGNQewLvdj2w9Jwmwc+V7dtxeh4NsWWZbk1veJm5chIoUK+lJEFYcltLgD0
GaQ6OkYaGvNI9aQwj7I722ypH0AYXD9CGrl+l1ULyx5nOosg8FTQE5vd9aCFx6mY
lUcwiAWs2t52o848XhjRsMXIt4VJ+9W50UeETtAwyneGkDpHXm/n6Gp3RpIEEsmK
jPGv2CWr/lr6aS7hd+jTfv48eOrIu2zMI3Heu/vSv5nJFdPFf21c6KHo0CI58/ib
7Xl1LbUO3mhFK4evd024jEZW4rQaUVnQGJPVmQYvDhpST3F+2oa6EXj2hmPsPpHP
gvW8G72LvNNfSeCX5qtDV2TbdHBoOeR+tpMq3WyAygPbRUd7AjKdPjk4V7IwhrJs
5ZAq6g7lcO4FuY/yOXyq5GQcz9694w5BsWmdsIjYi7kSOx5BHEHwNy5Sh+ldeoUC
TOjVsZdSPBjFhiLAlFno4FqvFygE7xIo4MPBzEX9ba+Z59fUYN4xhWo2qDQhqDKt
T1y5eg+sBxi+P/LpJ0V7nUT4tc4ZjWs7ok5xRGqzDo4klTW881uqqN8fwZyw21sf
kmfm7uuRsWCajTpj5zKZ
=2ipj
-----END PGP SIGNATURE-----

--9JSHP372f+2dzJ8X--
