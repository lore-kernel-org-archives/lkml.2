Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab1KDRpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:45:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:40864 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab1KDRps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:45:48 -0400
Message-ID: <4EB424C3.5030508@nod.at>
Date: Fri, 04 Nov 2011 18:45:39 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: menage@google.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org
Subject: Too early cgroup_init_early()
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig051F90A2E7054692F988F83B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig051F90A2E7054692F988F83B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

Is it really necessary to call cgroup_init_early() before
printk(KERN_NOTICE "%s", linux_banner)?

IMHO the Linux banner should be always the first line...

---8<---
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.1.0-09317-g9b89480 (rw@raccoon) (gcc version 4.5.3
20110428 [gcc-4_5-branch revision 173117] (SUSE Linux) ) #2 Fri Nov 4
18:32:15 CET 2011
--->8---

Thanks,
//richard


--------------enig051F90A2E7054692F988F83B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJOtCTIAAoJEN9758yqZn9e6sgH/A1Yn3FPIUjS9FSsPCWMSQ6B
2dtY6w/cg8CLrufrJRSgYtjgFbyWTpFRJoImojDerARkoMBhS1Oroq/GdDvXDZO3
lOMTZwND7mT0ypv2zMupbX7AhzPKyXjRPAWGBOChc1cwwPVgoGcmloNESvOFAxtB
I6HvyQs0jfN/lAGemrlVhKBnP94jHAuCeda8MpVf67Gx2c7D1HibGeSDLJ0jBvET
O4H+vvxPF0CvrBPw9kOOKmeUeh4Yf0x4dHalBKvT+MJOEHdBrEunUlnEviSEW4BQ
gT5jNxvWGvpuCYMQLJa9P0Sywc9/s07EDUIAuOGkll9RFimgzaD0eXsS3/yPD8s=
=Q8OT
-----END PGP SIGNATURE-----

--------------enig051F90A2E7054692F988F83B--
