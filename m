Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1LGGvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:51:14 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:40783 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775Ab1LGGvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:51:13 -0500
Date: Wed, 7 Dec 2011 08:51:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression] Re: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
Message-ID: <20111207065106.GE32368@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309427470-605-1-git-send-email-balbi@ti.com>
 <1309427470-605-4-git-send-email-balbi@ti.com>
 <CAMP44s3hFyAK+1W6eU30RNn3=cPDRGKXW+E+sDoWNrNhU0ZpPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AsxXAMtlQ5JHofzM"
Content-Disposition: inline
In-Reply-To: <CAMP44s3hFyAK+1W6eU30RNn3=cPDRGKXW+E+sDoWNrNhU0ZpPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AsxXAMtlQ5JHofzM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2011 at 05:28:58PM +0200, Felipe Contreras wrote:
> On Thu, Jun 30, 2011 at 12:51 PM, Felipe Balbi <balbi@ti.com> wrote:
> > ... and use threaded IRQ infrastructure. Later
> > patches will come dropping both workqueues and
> > setting the nested thread flag.
>=20
> There's something wrong. When I boot my Nokia N900 with this, as soon
> as I press a key from the keyboard the whole device hangs. I don't see
> anything on the console framebuffer, and with a jig I can't boot from
> MMC, so there isn't much more I can provide at the moment.

Funny, this booted fine on my beagle and MMC card uses a twl GPIO for
card detection. Maybe it's something fairly obvious that I missed :-(

--=20
balbi

--AsxXAMtlQ5JHofzM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3wzaAAoJEIaOsuA1yqREeFUQALFNewYYn61FnaOk1lx9ZK+l
xSjnCDxETUKPpxr6MT8CA+3d0JEwJpyr7vjSdpPAeQb2N/BsCQ2dC7t0jwRd+igK
zz4AIrTzM3iZZklHBcR20ddFKovyWsCzTlLkWELIKOr3a8L4ODrSAV1N97NuRAgN
vI/ZAVWgFKmOw1m6SAHvQAm82rJgcM0/KiwfWZeG2QT2yeGw4uuZTKTkqWCugk6n
VfbDpTzx7ifn+V2okJw+7EFxfXkkYih/Tgq33yaFCsZHfuFtJjKJxYwG6vzII8gu
23DtbBYYfLD09ob/5dkc7zAEKNKcTJ+RnhKL4pQl/sijfDH0kxI0L7VinsWPQ0US
jIK9lRelYTkLH6sR0Kn1Fqxo05JTLXkgVSJPjKEOcUD6KUN2jdaD4I28Rs/9Sgv0
C5rQwlxi0/O21zeNf0cTf8+uU+ZJMGhgtSAi0V7SXs27YCuFzdT3wz/ojCWHEdD+
sl6A0UXuBOxsQnJpI7Hzv1LBOmp8jo/Rn5AugX/iN7DvIgpDDmR8dlTsnrNyG8eQ
BNODMqzgNVN+QNi/C7SqW8XOcUIS6GzYPizHeHDOywzLydNvns7kduIVNDkaGYzZ
s6zN9hBRbDgUw2jSv+GZcPFOCIE+DMg+0Sn+OVAg4Y/dHSAqRUmZ7HnZznOjuk3I
1qAeCd1v99CdIfGItnTw
=2oVS
-----END PGP SIGNATURE-----

--AsxXAMtlQ5JHofzM--
