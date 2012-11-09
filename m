Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2KIMAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:00:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54849 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab2KIL7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:59:55 -0500
Date: Fri, 9 Nov 2012 13:53:44 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121109115344.GB8078@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50929233.7030609@gmail.com>
 <50967BFD.6000308@gmail.com>
 <20121106112751.GD11931@arwen.pp.htv.fi>
 <CAOUdcc_z=LbvNmapSKA0n7bny6wO+Ke67BQtF9J87TkV=ygSbw@mail.gmail.com>
 <20121108140649.GD19533@arwen.pp.htv.fi>
 <CAOUdcc_9UTZpdu6k7wyQc9Hjmv-0YgAGiwsm+NysEmS9VUxu+w@mail.gmail.com>
 <20121108193034.GB2962@arwen.pp.htv.fi>
 <CAOUdcc839T6xrVxX6YcFCs_X=PkyH=3GyLHs1s+pzgWz0faQtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <CAOUdcc839T6xrVxX6YcFCs_X=PkyH=3GyLHs1s+pzgWz0faQtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 09, 2012 at 10:31:47AM +0100, Dmytro Milinevskyy wrote:
> Hi Felipe,
>=20
> On Thu, Nov 8, 2012 at 8:30 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Thu, Nov 08, 2012 at 08:07:57PM +0100, Dmytro Milinevskyy wrote:
> >> > On Wed, Nov 07, 2012 at 02:14:00PM +0100, Dmytro Milinevskyy wrote:
> >> >> Unfortunately I have some issues with git send-email.
> >> >> I've attached the patch itself ..
> >> >
> >> > I'll apply it like that this time, but try to figure out how to send
> >> > patches properly. We have some very helpful hints on
> >> > Documentation/email-clients.txt which are hugely underused ;-)
> >> >
> >> well, I try to follow the rules as much as possible as long as tools
> >> work ... =3D)
> >
> > git send-email has thousands of users and it works fine for them
> > (including myself). Maybe you just misconfigured it ?!? ;-)
> >
> No, I was using it in the past w/o any issue.
> In fact initial versions of the patch were sent exactly with git-send-ema=
il.
>=20
> However I lost my internet connection at home(some issues with ISP)
> and at work place network environment somehow blocks
> git-send-email(though thunderbird still can connect to the smtp server
> ..).

I don't think smtp server can make that distinction. Except for the
message-id, there's nothing there which would help smtp server to figure
out you're using git send-email. On top of that, it would be just extra
work to maintain rules to block a tool which is essentially just sending
an email.

Make sure you're not missing some authentication with the mail server on
your git send-email configuration.

my 2 cents.

--=20
balbi

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnO7IAAoJEIaOsuA1yqRE8v0QAIS4e4Q1CirK6WwethA2U1m1
Q5sFKm2hH7iPM969HyKO/VYexI356ll+D0Wh9M5Fc1GkkjropnwAuixQQd3tpMvW
1pheVcj+2MeCqNW/fYRRW2c8FMuehOOgXN5VVMG1tM7DhZmHZvkB3+vwYDh8MDqJ
DgyACuib7NNYgNnTEMR8XKBIHfNexyRrYJR6kBjN6ztMXR9hRKYdMw2fCyy3HkEW
jo2ENJeEV3qwnvzbzD1+MVKHi29Z1gdXurrZhmjFNHI4cPQGe19UpDV34+uXB4AA
YA2quayHpo8+kvOzq8VimajkyoUTEUyLaV9j7PfKWjYF1kiMEL8m2jenHypBV1eH
YLrLeExt7bGZcYfMwBxezTm8hW6PD1czt+tCALrAgPqgxREg+a6P0XCK4gSBvOA/
R3PFhhye6Nd8/bPcuQMU6Y9CxztBqyz6lOMG1B7r/ReajTgi9YT0UvTUfOgUMkyP
y3BWgNSOHI5HxsJ//xrK7VpRee7dc+h9sawCCTG91ttOrBohh5skdxo51n0NgIR6
12/hoNylg211Eb2yi0oB/bQfAA42NythVrhLbY/izIQvgwDnye5MWt8goulGgUcZ
tjOwJLF5tJ8FV+uibQ9YwyPFtVKwFQdUlmUy/OyAWfhhnRILnvtj+N0OFXtBN9Ng
hR/EuVJk1fWHPh0RuFmo
=HENr
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
