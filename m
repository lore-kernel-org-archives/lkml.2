Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2D2XaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 19:30:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab2D2XaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 19:30:09 -0400
Date: Mon, 30 Apr 2012 09:30:02 +1000
From: NeilBrown <neilb@suse.de>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
Message-ID: <20120430093002.472dfdde@notabene.brown>
In-Reply-To: <CANOLnOOQDxu-P=yTN6159XJANq-_FSCtZ4rBt69NSCPjLz1Rjw@mail.gmail.com>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<CANOLnOOQDxu-P=yTN6159XJANq-_FSCtZ4rBt69NSCPjLz1Rjw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zSwXBRtVkfNvnqhYrj/p1k5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zSwXBRtVkfNvnqhYrj/p1k5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 14:31:13 +0300 Grazvydas Ignotas <notasas@gmail.com>
wrote:

> On Wed, Apr 25, 2012 at 10:33 AM, NeilBrown <neilb@suse.de> wrote:
> > Following are a collection of patches that I've need using for a while
> > to make sure the charge-from-usb on my GTA04 works.
> > Hopefully I've included the right people in the recipient list :-)
>=20
> You missed the power supply maintainers - ./scripts/get_maintainer.pl
> is usually good at finding the right people, although their
> MAINTAINERS entry could be better I guess..
>=20
>=20

I guess you mean:

POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
M:	Anton Vorontsov <cbou@mail.ru>
M:	David Woodhouse <dwmw2@infradead.org>
T:	git git://git.infradead.org/battery-2.6.git
S:	Maintained
F:	include/linux/power_supply.h
F:	drivers/power/power_supply*


get_maintainer.pl didn't find them.  The F: line seems to say they aren't
interested in individual drivers...

I'll include them if I resend.
Thanks,
NeilBrown

--Sig_/zSwXBRtVkfNvnqhYrj/p1k5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT53O+jnsnt1WYoG5AQK78RAAq6bgJypEJ3LeuH+EiEzQEWna4Gum4rsi
7qL59VkLqVEQWhgRG7kVBG0gP0xsreVPDy9J2ttDKA1CCKWKvy69m9Cn1EkPpZ9e
bC/cLmHzujjXKz02xZPMp7HlRi2bcdAxzAKcmiN9sYLPLXC8MYL+kg1/v1tKWY+Y
T7HN5MmcN32BQvelDTI0N+GDFmfRkbuvW9FpGkg+MmfRnbQTcaeGohfA1wTMcjwX
uKsgwIynypMHOt9YrxA6fGQeycIHdK5Qb6uxtBwFJEKDxaxmfdJWXSFUC6jhtZHZ
Cnx/J1h5MB3htl+MdA/IFVu5gbF7L8IxnpcCEfrRQqKVWfvveWCOQJGD2l8igzQs
Jz5N2OU/lqfZq2FjQzla0h6w2hkpn0xU2WteG3XE46r22pZBQNZee0c0TSmmzB7B
R/pG0tnwVe9stqVaSsozuoiLloz6+TwdOA7MKK2IVLhH46bBGpw3pJzyxM7Tja53
xmwoFwT8IgYzMro1tMqT6GG/tXOBQWD4P71d3/JvfLPdKiXQoBkCKxTs7aUCePra
FyJjb1C/vCR9NlyvCEJK6wTCtUzQ8WGElqwNFVs9gL03MSaUsw6fP3sd9VRbvp4Q
WimxDOiNahGevVW5Ni4Jw9fBKwFdjlzjHMLR/iKNKT9Kr+kPSw601E+sGZKPB50n
LCxqrycDCA4=
=4J7s
-----END PGP SIGNATURE-----

--Sig_/zSwXBRtVkfNvnqhYrj/p1k5--
