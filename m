Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1F3ONe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:13:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39337 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1F3ON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:13:29 -0400
Date: Thu, 30 Jun 2011 10:13:23 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 2/9] KVM-HDR Add constant to represent KVM MSRs
 enabled bit
Message-ID: <20110630141323.GB4823@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-3-git-send-email-glommer@redhat.com>
 <20110629215608.GA3557@mgebm.net>
 <4E0C3458.6090801@redhat.com>
 <20110630125938.GA4823@mgebm.net>
 <4E0C7872.9060002@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <4E0C7872.9060002@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jun 2011, Glauber Costa wrote:

> On 06/30/2011 09:59 AM, Eric B Munson wrote:
> >On Thu, 30 Jun 2011, Avi Kivity wrote:
> >
> >>On 06/30/2011 12:56 AM, Eric B Munson wrote:
> >>>My mail provider seems to have dropped patch 1 of the series so I can'=
t reply
> >>>directly to it, please add my Tested-by there as well.
> >>
> >>How did you test it then?
> >>
> >
> >I built host and guest kernels with the patches and pinned a while(1) an=
d the
> >CPU thread from qemu to CPU 2 on the host.  I then started the same whil=
e(1)
> >process in guest and verified that I see ~50% steal time reported.
> >
> >I then built 2.6.39 (just the code I had present) on the guest and time =
it
> >while it was competing with the while(1) on the host for CPU time.  Next=
 I
> >built the guest kernel with STEAL_TIME=3DN and reran the kernel compile =
to make
> >sure that there weren't any huge variations in performace.
> >
> >Eric
> I think what Avi means is, it won't even compile without PATCH 1/9.
> If you don't have it, how could you test it ?
>=20

It made it to several lkml archives.

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODISDAAoJEH65iIruGRnNE8kIANvvhxLyKJqm5FOIv/SbZ14Y
JE8T/I+eUwqHRwjnOeDQv3nGYZLsUVpsLxHQkZbDKdTNsDF/oUOuQDdNHD/DgPV2
xrwZR9szMeHa3xvg2+LGTAmvw/rxXuPd8qqYLFC3GpKtboQbmhvXh+enWzeeNoq+
qNjAJ6iBsZFRmDrHsFMwKDCTteuZKum9wawWCoIrlG0ZH2/AevbuY77nm34CatfS
BRXvJ4ngG+ZPzrgN2E9frlopRDhPXHBWR2X9i+ckDfZ3mLxqO2SIe7NDPmvmwzP4
ANVqTU1/oRCjCi5XD2KOvFunCo8nF/QhLUJUap+bN6PiaVdTcQYkIDPY5XEi3ek=
=SLGQ
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
