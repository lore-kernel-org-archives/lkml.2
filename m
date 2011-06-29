Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1F2V4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:56:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42876 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1F2V4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:56:46 -0400
Date: Wed, 29 Jun 2011 17:56:42 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v3 5/9] KVM-HV: use schedstats to calculate steal time
Message-ID: <20110629215642.GD3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-6-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-6-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jun 2011, Glauber Costa wrote:

> SCHEDSTATS provide a precise source of information about time tasks
> spent on a runqueue, but not running (among other things). It is
> specially useful for the steal time implementation, because it doesn't
> record halt time at all.
>=20
> To avoid a hard dependency on schedstats, since it is possible one won't
> want to record statistics about all processes running, the previous method
> of time measurement on put/load vcpu is kept  for !SCHEDSTATS.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>
> CC: Marcelo Tosatti <mtosatti@redhat.com>

Tested-by: Eric B Munson <emunson@mgebm.net>


--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC5+aAAoJEH65iIruGRnNfRMIAKWSlVoHt3m1V/3SoT/KJ+Zi
vwKn9Rz9UkY2p/XkqNu12Y0HuqSzTgHTql0xsZ1EpfBtudSDq+6QqP4ryMH/ulwH
jLBKm/FLwK0/888lHoIjzOwnQzbuLcQdHjGjZ2rbjqtRstmy/jO50vu8faI3EDAq
tycF1aUGwexzOGM0wWIaFylyunoEg89lpmlut6ieDpApCAHlyqRbftZgMubzM1yi
HxTexqRvlBiPmmbnXPsAyZJOdFhZscWG6SCQs+STbGgmMY+YviendDnzwC5IXbf2
EU/EOINcicYSx1AxDfn0+EjMZrj7ReZFJI2fmNM2dRN1eZ7HL4W6LifctSJuTP0=
=BFMH
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
