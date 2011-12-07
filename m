Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1LGLa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:30:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab1LGLa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:30:26 -0500
Date: Wed, 7 Dec 2011 22:30:03 +1100
From: NeilBrown <neilb@suse.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: balbi@ti.com, Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [regression] Re: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
Message-ID: <20111207223003.0a0ae278@notabene.brown>
In-Reply-To: <CAMP44s0psqeMEh8vgYSfV=MAqSOJ6+EpWndXpc89qfGHMX_f=w@mail.gmail.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
	<1309427470-605-4-git-send-email-balbi@ti.com>
	<CAMP44s3hFyAK+1W6eU30RNn3=cPDRGKXW+E+sDoWNrNhU0ZpPA@mail.gmail.com>
	<20111207065106.GE32368@legolas.emea.dhcp.ti.com>
	<CAMP44s0psqeMEh8vgYSfV=MAqSOJ6+EpWndXpc89qfGHMX_f=w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_xP0y7muJyQ6j+mb41pKaKB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_xP0y7muJyQ6j+mb41pKaKB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Dec 2011 13:04:03 +0200 Felipe Contreras
<felipe.contreras@gmail.com> wrote:

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
>=20
> I'll try to flash a system to NAND, since I can't seem to just get the
> MMC to work when the cover is open and the device is connected to the
> jig to see if I can see something from serial console.
>=20
> You don't have any idea about what to try?
>=20

 Try the patches I posted to linux-kernel on Nov 27:

   Subject: [PATCH 0/4] fixes for twl4030-irq in mainline

and following

   http://lkml.org/lkml/2011/11/26/92

I think I hit exactly the same bug and you and (eventually) fix it (that was
a fun learning experience).

NeilBrown


--Sig_/_xP0y7muJyQ6j+mb41pKaKB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt9OQjnsnt1WYoG5AQL9KhAAsgaQwChMwYYv5jnspM8HPKt4f4zmS7Vz
O9WrTwVRorQhxwoBvQNDKzqLTYhtMXETtXtUfe/x5GP5qe01HJLpCOhzoxHOiWK8
V2v2DqZE+jOeYIfwz36UJoCbEl5ikHG51EaTNK3F+Kx96COKslh3gfe+t+eKdZQG
aVS+oRh7nmDm+LZhL/kmWlpCWMV1mPmK4ibeYprEfzxbNRsjVQsgC7XYuiSwkyQJ
rmjBxVI+OKrCn8qLhLcktQAPsWHLpPZ21DHHXVSRXXKeEjFQGa2fFJvUxOaL4FQ1
lsvaTZ4vpFvEowOVAhV5sE31+4LucBPzP8kr1D/v4y+18V7IyYWj0M9vtdsjdPzY
I5QEea75N8/s8vxgGkRJh4G0P5mncvg6tB2pkGt/AdoPBCpt7k5j6H2v+Yy7THTr
unFKcuz8ZfKteJM4x+IkamsG4bnzzdhrq6mJ4SSVKO2NXAhVfGRu2LEi/fWCIMQw
MQ7EFgeoLKgFI6zy5tP3PO11A4qaDFGj+F5tlyhbPIUWGXwiHGqp0RRQM/gd0V2g
Jae1k4KJpJ2ygsrQRmcq/VfzNYbhRwRY8ksKrHI57yp/I7MLmRL+qRsIJT0DbJmK
sorvoPLvO+rMz6BGBYULQqLM+07X5eUvu9fjDuUGLFP6936tTfIkh/+4Tcj7xeZJ
7RR7JI06MPc=
=BlEV
-----END PGP SIGNATURE-----

--Sig_/_xP0y7muJyQ6j+mb41pKaKB--
