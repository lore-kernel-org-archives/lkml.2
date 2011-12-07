Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1LGNjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:39:55 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45651 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915Ab1LGNjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:39:43 -0500
Date: Wed, 7 Dec 2011 15:39:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: balbi@ti.com, Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression] Re: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
Message-ID: <20111207133937.GX32368@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309427470-605-1-git-send-email-balbi@ti.com>
 <1309427470-605-4-git-send-email-balbi@ti.com>
 <CAMP44s3hFyAK+1W6eU30RNn3=cPDRGKXW+E+sDoWNrNhU0ZpPA@mail.gmail.com>
 <20111207065106.GE32368@legolas.emea.dhcp.ti.com>
 <CAMP44s0psqeMEh8vgYSfV=MAqSOJ6+EpWndXpc89qfGHMX_f=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AOcQtsuew1iUDr5s"
Content-Disposition: inline
In-Reply-To: <CAMP44s0psqeMEh8vgYSfV=MAqSOJ6+EpWndXpc89qfGHMX_f=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AOcQtsuew1iUDr5s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2011 at 01:04:03PM +0200, Felipe Contreras wrote:
> On Wed, Dec 7, 2011 at 8:51 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Dec 06, 2011 at 05:28:58PM +0200, Felipe Contreras wrote:
> >> On Thu, Jun 30, 2011 at 12:51 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > ... and use threaded IRQ infrastructure. Later
> >> > patches will come dropping both workqueues and
> >> > setting the nested thread flag.
> >>
> >> There's something wrong. When I boot my Nokia N900 with this, as soon
> >> as I press a key from the keyboard the whole device hangs. I don't see
> >> anything on the console framebuffer, and with a jig I can't boot from
> >> MMC, so there isn't much more I can provide at the moment.
> >
> > Funny, this booted fine on my beagle and MMC card uses a twl GPIO for
> > card detection. Maybe it's something fairly obvious that I missed :-(
>=20
> Did you try typing anything? That's where the problem happened on my side.

beagle doesn't have keyboard ;-)

> I'll try to flash a system to NAND, since I can't seem to just get the
> MMC to work when the cover is open and the device is connected to the
> jig to see if I can see something from serial console.
>=20
> You don't have any idea about what to try?

you could cut the back cover so that it just fits the device on the jig
(I did that to an old cover), then it works just fine :-)

--=20
balbi

--AOcQtsuew1iUDr5s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO32yZAAoJEIaOsuA1yqREJqoP/j1TD8RdbgxFXmjyq/RUqX1b
STRxkd+aMLYLMr6Amhs8NwNh7YtoVR7516Lq8gBKRUFHcHQ8Rq4xi8/pNUS8E6NU
zUErZzjq79rbyQ7QW2SJiffnYyyN8EG24pwuCLRrUSnhl1Lse5H1VsEMM5/32hc7
+weR3Ue8iD2qojij8xNtqbCvjbMQbqqHo9fP1lVj/iplhHiN5AZu8a/lsYD9MVJN
vh/NC2kIrVR1zb6sOT9E0yr/oTR1foQbvp8nZPzQBJib7iToU6yu+q6fzeL57BWp
6YGNGwKPI8CYoWONnQMjC61Nhi+u3dSPWQiTdnDFcN0OGASUAgAm1MoJ3kxORR4J
Gj3pX6iOaEF7d7jIw5GE3my7gMLx9Mif90/+z+3EmRg8a7zsZ7r2SNofN1BZVJA3
bZQJNovjCIvg/6gwEXHXBfZtUghlaLsM8bM4ACru1zviKuewHFGMHh4EBhxtm3k8
jQCoDlNnmRM490UV5ROOnHFu5E6pmn3twyuZMcmJ34glgVQvqSZR3o3RHgbCJ0ZX
UFCJ7O6yXobcPFXgjcZ7nMRbhdHk7bORbbIITEU8FB4/9uGEPRuRqbv0Jzxkm8WR
JL5CvcZoo7fFueKVRtz7q6MGBSF++bQ2lQBPfol+/njQnBueGlQ/sp1A4mFRPkaN
MRUsy5GDgiIAsByekbGv
=lfzF
-----END PGP SIGNATURE-----

--AOcQtsuew1iUDr5s--
