Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2I0TuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:50:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2I0TuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:50:08 -0400
Date: Thu, 27 Sep 2012 21:50:00 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH V2 0/2] Support for configuring polarity of PWM
Message-ID: <20120927195000.GD5483@avionic-0098.mockup.avionic-design.de>
References: <1346908203-10632-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <1346908203-10632-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:c25arj3Fith7VApBv8ueChdAHRqfhV1tSlhUJxDPQta
 RS9g5SR3weMET+6ZSCUZhqT1ZA7NQBPgmol8M69QbkoS7933Pm
 PJgqL7L6LR7KWsIF/fmfnhpEqADH2QULKDCDFl9AczufDfyBfO
 ZlofDYPkTDU0w1ctymNjjljFYuGNkOp1ipkQUHUGW+Q+2MXREi
 ELnZ2gDXcy6ImIB44kda8PfmoktvkZ9naKV6yxAtMj48G4T3KR
 6Zeg9yuiN3/jK2zEQkaIdPXZiHn7TV5yL0nhKUT9bJBO1NdZDd
 LxCFc2/DW024+JOQ6CPlvqSlXDh2Vz+BhYC5jNb0acfN2pph7M
 v2YA+Bot/13bbE22ZhC62ta1eS7WPT+tuD57ggsBWx0VmFo3N7
 3wD7toQCUVQcDa7uuFl6i71Kswhu97Wxlr4T1wxDUOCm620Mq7
 PTPsj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2012 at 10:40:01AM +0530, Philip, Avinash wrote:
> These patch set adds support for configuring polarity of eCAP & eHRPWM.
>=20
> Philip, Avinash (2):
>   pwm: pwm-tiecap: Add support for configuring polarity of PWM
>   pwm: pwm-tiehrpwm: Add support for configuring polarity of PWM
>=20
>  drivers/pwm/pwm-tiecap.c   |   22 +++++++++++++
>  drivers/pwm/pwm-tiehrpwm.c |   72 +++++++++++++++++++++++++++++++-------=
------
>  2 files changed, 73 insertions(+), 21 deletions(-)

Both patches applied, thanks.

Thierry

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQZK3oAAoJEN0jrNd/PrOh62AQAJ7+Z4AwMkWw5sJqMUqoCn75
Uss4lthqyGmSlgJ6ndfYz8F4wmyeH/OgQYBxobImfNJUC4pdwOgMg3axWZp6z/jn
GvjEZ0aoaHnMYjTLKeYFuv1y5HsrByjSVuxAumJNKxtn3/BAO6R6P7YW77Kw/493
m63zOvWZ36hClH9mbfVzvLLLu8QkOCuTptOfX+IdtLw6jSGRfeG4iDXm4JgzlC+N
EClgsj2qRF3T54vfr0g0txTQSD9GREkIlP68G9w/6VhLfpY5ce6bvKP5ekr4ct7h
+S6/1bUBp2voB/bQS4n7GhEaejFXkAwlO5TKEyudqJrl7tH7QbMWhrdKvfcHiL6U
uvZZ2A02IPeUtlUpsC5bZ6REZZv3em6A3lXgqV5x8okeknvzmMVIvNJ0u1hsbvzO
uuDu8hqHw2Lxt/elMEC3NzOD/gucuhYmMhbXfF1i1RFk530+tMX5nJhQgPMHCuxC
+b3hP8RuaLlzpRjCs/K2gE2OuBdR/zj9fF0CGg9uvGAeJHf6hotkAJxpYc33Vj3E
iBbU0HmwV0do+4lLJp+QeMkCXH9u+1YL3kaAT4wRYku6X8K/u1YXuwO2yx0Emk2V
yd7Kkc52LGECiG3FHO5fRfS00EA06GQ3FkF9UpbDIsoftA/unVy7YiD9+0frw0f9
AEgvDi58HEMYc5AwdF6+
=1cVm
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
