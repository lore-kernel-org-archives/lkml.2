Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab2GHKaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:30:22 -0400
Received: from nn7.de ([85.214.94.156]:53344 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2GHKaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:30:21 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2012 06:30:21 EDT
Message-ID: <1341743017.7379.6.camel@no>
Subject: google chrome / chromium hangs on 3.5.0-rc6 but not 3.4.x -
 threading issues?
From: Soeren Sonnenburg <sonne@debian.org>
To: linux-kernel@vger.kernel.org
Date: Sun, 08 Jul 2012 12:23:37 +0200
Organization: 
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Gb/TX/rF0bHV+sMs7ZRu"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gb/TX/rF0bHV+sMs7ZRu
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

there seems to be some weird interaction between the latest (git
current!) linux kernel and recent chrome/chromium releases (>=3D 2X.X).

Basically chrome fails to open various web sites like https://github.com
just hanging (waiting). This problem is not there with older kernel
version (e.g. linux 3.4.4).

Opening chrome single-threaded works all nicely. A gdb backtrace of such
hang and some more analysis can be found under

https://code.google.com/p/chromium/issues/detail?id=3D136258
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D679827

It should be noted that chrome 18.X is still working with the new
kernel. However, klogd also seems to have some trouble with the newer
kernel utilizing 100% of the CPU but not with the older ones but I don't
know whether the problem is related.

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-Gb/TX/rF0bHV+sMs7ZRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJP+V+pAAoJEH82z1Wqh6p3zKsP/iHLeYh0QdgWF16RhiyG2Zl/
PqG2FmHtpL2ixK6fnL4EO33z3dakDL6deBm3vgjGlfWEW83MktJ9L6GEkETycubj
jyHKrrz1i1up1iu1icl386Ua0D7iiRv8X3hXeYkqxx2IPl9f96Dyg0FcNz4Ixg5D
fK+dRK93SdGOfOq88odEwMHXTamw07ZXNqSlhhjOB8INhmHXDfkeIusv+zgm2iwX
Lftp2hFLGvHYeK+38Y0erFbwJJmxmyvSB0h5q9ZJvZTsnCo6cz6AVH+pu0bjJvox
0dR/tTx+yiDB0hvh1GlSEvTymiOqFJdcvSRjtcFYQZPiYKWnJ/XTzY99cFmIU31F
ekW+M+cwc98CaDXMskH2UtN7mbOWxosw/VUwSVu2tJR9sU4WFtNjCPpLzCVYYLJY
noqYQmz49GrP9ypS70W0Dafy5HWhwTtzucu9eojT2pyO9i112uT32SToKqDhnjWI
J6O8ziKlFRl89V3AmXaF5GTknZuAu3mSXy81VGRZ/fxJPmu5PPxW7vrTtgI/nGGP
NiPHQy70DY3Rftb6wz94huEM0CjqqJV+YFY6YTpkWcwiv0g1vkssUSdfmKXouvDs
PVKXGlTGHZbpTErnNxHzURWSZgwFrGWAdm3PcG6LMc42mb08SPnd+vVu9T7rnb0w
QrHHpSKJDa64IHxBRbGP
=sQ2o
-----END PGP SIGNATURE-----

--=-Gb/TX/rF0bHV+sMs7ZRu--
