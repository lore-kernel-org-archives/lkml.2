Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2JNJ11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 05:27:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43898 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab2JNJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 05:27:26 -0400
Message-ID: <1350206827.4832.74.camel@deadeye.wl.decadent.org.uk>
Subject: Re: stable backport: sched: Fix migration thread runtime bogosity
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 14 Oct 2012 10:27:07 +0100
In-Reply-To: <1349897043.24256.63.camel@gandalf.local.home>
References: <1349897043.24256.63.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2SLqQKny0SnS+oYiSPNB"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2SLqQKny0SnS+oYiSPNB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-10 at 15:24 -0400, Steven Rostedt wrote:
> Greg, Ben,
>=20
> Can you add this commit to the stable branches. Without it, the
> migration thread's accounting is just totally screwed up:
>=20
> By running a simple shell while loop along with a ps loop, top shows:
>=20
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND     =
      =20
>    17 root      RT   0     0    0    0 S 9999.0  0.0   9:27.50 migration/=
3   =20
>    13 root      RT   0     0    0    0 S 128.2  0.0   9:50.23 migration/2=
      =20
>  2805 root      20   0  105m 1904 1416 S 13.9  0.1   0:06.69 bash        =
      =20
>  4090 root      20   0  105m 1904 1416 S  2.0  0.1   0:00.90 bash        =
      =20
>  2773 root      20   0 85484 3372 2620 S  0.3  0.2   0:00.03 sshd        =
      =20
>=20
>=20
> For 3.4, the commit can be directly cherry picked:
>=20
> commit 8f6189684eb4e85e6c593cd710693f09c944450a
> Author: Mike Galbraith <mgalbraith@suse.de>
> Date:   Sat Aug 4 05:44:14 2012 +0200
>=20
>     sched: Fix migration thread runtime bogosity
>=20
> Below is a backport for 3.2.
[...]

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-2SLqQKny0SnS+oYiSPNB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHqFa+e/yOyVhhEJAQqMiRAAy7nTFReXD/fSAeaBD1nvc9qRn9zbsWrR
tdi4hFXwernp9904ElOMArRcWjhPwyXuVsU5pztMM6It6jpEXXkdgNfDw6pdr73z
BzNzFcDPhTPoxTi2MLE4DRmddINMj3Q1rFHQV44ZLJBX6A6leIVI0+3lfg3OLEfT
eruk5YQyDrFgOvUTrI/YOj+obPNVr+wMnNqcqUMNIGGcubTXZTZJVazm5XSwxP2O
OWWlzhGibWYOEA/adS1FXienoDEntbyzNtZNXFmOto2eH4ktPaLQc8Hc/VgOqkhj
8deTGZve16T3yn+bHFs8S0a53xw7lraDHSrhHGLgfaTiGdUt/dkMUaoGfENeea+l
2VFMg6aiqgbtS6Mk+6OrAxIyZH2IZqZ0Ngv43SvtWfeFc/8HjPmSaTWB029WR9wa
c/tJuJSRzDbD4lv51PlEb2viNE/vFqr7/NP3QW3fRCfyeN2HW+WPO6AKE4dG/uRf
AZksaTyosYupVlAnDP7e3iCkBiYvtk+nAn6UXV9R+VB5i8SiOoI1W0iZ/xmNeat0
fndidtkJmz9GR9btyLaXyvIxC9dgCBYAT5duhsjiFUSwjLWMAVn/6S994RGOBsm5
09nLgd7+IisQeULI+9LeMueAomibbqVBONSqFWCgZ6KVxmp8XXX2QH7E3MI3qdhU
7uMe1n+297Y=
=gh7U
-----END PGP SIGNATURE-----

--=-2SLqQKny0SnS+oYiSPNB--
