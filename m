Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1EaAia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:38:30 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:52358 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab1EaAi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:38:29 -0400
From: "Witold Baryluk" <baryluk@smp.if.uj.edu.pl>
Date: Tue, 31 May 2011 02:38:26 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Harry Wei <jiaweiwei.xiyou@gmail.com>, Andy Lutomirski <luto@MIT.EDU>,
        Greg KH <greg@kroah.com>, Andres More <more.andres@gmail.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [Oops 1/2]Something wrong with copy_from_user() function -
 possible false positive due bug in gcc 4.6
Message-ID: <20110531003826.GD14366@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-29654-1306802308-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-29654-1306802308-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

You my wantto look here

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D48880
and
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D46639

It is regression in gcc 4.6

Particulry this error happens in binfmt_misc.c file.
gcc 4.6 errornously print error in this file.

However I could not find such behavior
nowhere in rest of kernel. But it can still
be a case If you use gcc 4.6.

If you are using gcc 4.5 or older, it is probably
genuine error, or someone is using a destination
buffer which is unknown size and gcc cannot
prove it is big enaugh to hold data.




--=20
Witold Baryluk

--=_smp.if.uj.edu.pl-29654-1306802308-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk3kOIIACgkQ7ZLFFOttZ4L0HQCg9Kl8+wNa+G9q2dKjFhwfOvsI
SkAAoN9oF6HDPoFGsnvvvjPknPsoihTw
=y7S+
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-29654-1306802308-0001-2--
