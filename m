Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641Ab2ELAq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:46:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38612 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab2ELAqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:46:55 -0400
Message-ID: <1336783596.8274.486.camel@deadeye>
Subject: Re: [ 018/167] [PATCH] brcm80211: smac: resume transmit fifo upon
 receiving frames
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Francesco Saverio Schiavarelli <fschiava@libero.it>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 12 May 2012 01:46:36 +0100
In-Reply-To: <20120512003533.GA2931@burratino>
References: <20120509055032.096457048@decadent.org.uk>
	 <1336779723.8274.473.camel@deadeye> <20120512003533.GA2931@burratino>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gBm2dnMy/86XoQzfzrb3"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 91.103.132.49
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gBm2dnMy/86XoQzfzrb3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-11 at 19:35 -0500, Jonathan Nieder wrote:
> Ben Hutchings wrote:
>=20
> > brcms_b_mute() takes three arguments in 3.2.  Can you send me a patch t=
o
> > fix this up in 3.2.y, or should I revert the change?
>=20
> Sorry to have missed this.  Here's the fixup used when backporting to
> 3.0.y.
[...]

Thanks, I've queued this up.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-gBm2dnMy/86XoQzfzrb3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT62y7Oe/yOyVhhEJAQoblA//QIOvM/cAN6rpLERobr2Tp6klCQ2dXyEF
2mH0SUf7WM9+9Ozx+nZJ9IS48pgtm1VmemiZIhvho4E+AKavWJ9qPsK9yzuAtXf/
rqidVV06q3zwYCGeAF7g2cDrf+LntFHo09Qp+SuC8qQrmukEPm8/b1gp+6aELpi8
rBU3tpU5MTzYg4uJzbc42EcwMB0+fz+POiVFAIbvDMzwhiXzvymES+SdGavwF13U
B7jppQHFCqBeuoCjr7DNCXMHah4hy+mSROl8V6OYOmtsn2YojXzlo4BmuHzrvWGL
p7Yc3YU/KMBMlP5lM+DOh+b0xX3F1AWGbGKKcpwxG8FKfL6UZyoQNH2XdFQ1VYZO
ZMwoApYGK2skXu0pzXUHukWybYfbUeq5NmLYA6OdHbZfWUs1yf3B9avyiO7/EpAx
tJh0GsDEocJxcG/hpiTozBX/8rdPYw6heLeZtMqWZ2tVbCgO4MQLYFsf+fVV+F1G
ZpkFIo9oOXGxMV/5Q+F50MQfZEKMn2UKBWOPJGUVQF2wKNcHxHN6c1ZTSvvtGuFE
2AcKvXxIpc8A9g//NABRXsjF4PYoOkjOYcjiypPe2aqsE4nw3//9DHEMUwp+QASL
qCm5D2JW0uriHmxWBcfNTIgz0iMNVBv5oGKlal3DSd8N7pL7McnwfRyB9Hw+QC/A
ZEzipdMyucE=
=lwyt
-----END PGP SIGNATURE-----

--=-gBm2dnMy/86XoQzfzrb3--
