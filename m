Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1F3M7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:59:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab1F3M7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:59:43 -0400
Date: Thu, 30 Jun 2011 08:59:38 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 2/9] KVM-HDR Add constant to represent KVM MSRs
 enabled bit
Message-ID: <20110630125938.GA4823@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-3-git-send-email-glommer@redhat.com>
 <20110629215608.GA3557@mgebm.net>
 <4E0C3458.6090801@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <4E0C3458.6090801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jun 2011, Avi Kivity wrote:

> On 06/30/2011 12:56 AM, Eric B Munson wrote:
> >My mail provider seems to have dropped patch 1 of the series so I can't =
reply
> >directly to it, please add my Tested-by there as well.
>=20
> How did you test it then?
>=20

I built host and guest kernels with the patches and pinned a while(1) and t=
he
CPU thread from qemu to CPU 2 on the host.  I then started the same while(1)
process in guest and verified that I see ~50% steal time reported.

I then built 2.6.39 (just the code I had present) on the guest and time it
while it was competing with the while(1) on the host for CPU time.  Next I
built the guest kernel with STEAL_TIME=3DN and reran the kernel compile to =
make
sure that there weren't any huge variations in performace.

Eric

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODHM6AAoJEH65iIruGRnNWwUIAIw7yDzzyEPA9nMpWgkFgqDU
nMpsPjD7hh3/M6Sx589c59WfQYa2G+opksUhwB9chL/PWUA3XRlLG4X/TkfUBnoe
S5gzZbGxnxdeUTYRVTeDegWaxPtosz2n6bbe1xRWAPvgZJ2/r9mlDYEGmZ/Id2+2
ymWj2ZdkdaNuQms2n4KfADdvY0vJDrPkwIIgEMTpXaOLEsYFKQdNuUn9e9OnE1qD
vEGn1dwfg0/qspEnjspqYFjpMEAdkXPfCAYYEFKMpgY72CEScBKdC+EN2pO3X9m5
qwrCKJEAMBCos1GgL9totC0TH5PhtWorFQsdadkBP+T+LymNIztqoaPIesgY7no=
=OFsZ
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
