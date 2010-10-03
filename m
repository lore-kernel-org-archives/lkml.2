Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0JCW23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 18:28:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34191 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317Ab0JCW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 18:28:28 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Meelis Roos <mroos@linux.ee>
In-Reply-To: <-jYMINoCtaK.A.F5.8CPqMB@chimera>
References: <-jYMINoCtaK.A.F5.8CPqMB@chimera>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fBUJNKuSza/4ej1qR+F2"
Date: Sun, 03 Oct 2010 23:27:51 +0100
Message-ID: <1286144871.3916.185.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: 2.6.36-rc6-git2: Reported regressions from 2.6.35
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fBUJNKuSza/4ej1qR+F2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-10-03 at 23:15 +0200, Rafael J. Wysocki wrote:
[...]
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16971
> Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and w=
riteq
> Submitter	: Meelis Roos <mroos@linux.ee>
> Date		: 2010-08-19 21:03 (46 days old)
> Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D128225184900892&w=3D2
[...]

A patch is available:

http://thread.gmane.org/gmane.linux.scsi/62561

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-fBUJNKuSza/4ej1qR+F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATKkDYue/yOyVhhEJAQKblBAAjncdfMylRLqk6G6EN0CQsT6IevllWggW
BkxJYAyuQZFB3CxYGxXwebXBE5Kg88dFbQGY28oYV23mWZ5ZFmp1MxThcG3Si3bH
V1Jd1thw2917fcJMA3TGaMr4Fg1WbmJeKUfdBUSpGjPq0/xuljkrWLPYYVbFNISl
wse4+LMyuuOecd4lUJ6J8Dzl2qbXw1X3F73NcEmiBJeinxiDfHezCB47gFRtPAcb
Da2YpNEqaTm1JljEz3Z3d0Lhf6mLMukJ5uLe2IuWG+Ga5oetVOzypYXlwvjRkiCY
Dk794Ueirudmp3SS/WjQeTF9dKrDSGmBRXJ5KCufe5ntwdwpmBQ2ymXLKSKYWZE+
k2o3vwljZh1OvDBOx7L4/jy1gb3Q+kEjtNprKmWPErV1zvQlaJfyeZvbj1Zl0wLa
MAp6taMX/FsIrkhq8ZE13XRqT+vS4OqSKOTQygxp0hio5ko5oKOqxyJt/1xdYVOr
8I+/n+hzVni2e3fYJsg8RN+En+aidT4gFVl6GualpxuYXuAcs33fZ7618bexAN1g
BHRn4kZ/M/cSQqL7QVx81vElE5+lvnXVVPsKLx3Ri72NC5mqvd9a9FRajNU7hXhJ
8GET3xASMunXPFzV0B0fuFWvQNxeUCx8Kx6W1Lv9AilpV+6HYuNDv0MLinZMLLwT
r9gcajv5zHU=
=qFxZ
-----END PGP SIGNATURE-----

--=-fBUJNKuSza/4ej1qR+F2--
