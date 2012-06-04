Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2FDP3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:29:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab2FDP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:29:19 -0400
Message-ID: <4FCCD44A.3090500@nod.at>
Date: Mon, 04 Jun 2012 17:29:14 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/24] TTY: um/line, use tty from tty_port
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-14-git-send-email-jslaby@suse.cz> <4FCCA3A6.8080608@nod.at> <4FCCD224.1020307@suse.cz>
In-Reply-To: <4FCCD224.1020307@suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFDA9A2597D7A5BB745ED7A66"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFDA9A2597D7A5BB745ED7A66
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

Am 04.06.2012 17:20, schrieb Jiri Slaby:
> On 06/04/2012 02:01 PM, Richard Weinberger wrote:
>> I have two questions: 1. Are these patches also usable on 3.4 and
>> 3.3 or do they depend on 3.5's TTY changes?
>=20
> Hi, I don't think they depend on any changes.

Nice.

>> 2. Why didn't you use tty_port_open()/close()/etc. as Alan
>> suggested my in [1]?
>=20
> This was not intended to fix anything particular. If it does, it is a
> pure coincidence... These patches are a minimalistic subset to ensure
> every driver has its own tty_port for each tty. We will need this
> pairing later.

It looks like that it solves UML's TTY issues with systemd distros. :-)

> So the switch of the driver to the new tty port API, as suggested by
> Alan, is still needed. I might do that later if I learn how to make
> UML work. (The conversion is by definition invasive and needs runtime
> testing.)

Two days ago I did so but still faced the problems described here:
https://lkml.org/lkml/2012/3/10/163

Thanks,
//richard


--------------enigFDA9A2597D7A5BB745ED7A66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPzNRKAAoJEN9758yqZn9eiYEH/0eWoj8IG38N8ZOkDkECe3jb
Ogz0+vC5jCSzQbWA4FYrdIO43u69wy0woFjW5Y64tL8g6ys7QVa0TYg6EubEXRnM
y8wh4hb+7equ73piBITUT91GAJGIKZQS4aJ0lGdgSMYQxzIU5SKobBs8C47SnBa1
PB/h2aZy+jiacUx8yv4rBD9TVK/LctzD4+sTF4L28dfco/uZ9Z0fuTyhpAX4xRMX
M+iuTXAOxMETtxtbBmSSicBUZa5j/uQ3CiYWqgo+4x+SasePD+HHUtuuyiE7BoRX
wFdu+50fSpCf8Rbn13/WN4cYRS2tKFySF9E7a7bqZXmVuA7xK0z3+T+9pJe9bIM=
=DIpz
-----END PGP SIGNATURE-----

--------------enigFDA9A2597D7A5BB745ED7A66--
