Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1FNBVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:21:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47243 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1FNBVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:21:09 -0400
Date: Mon, 13 Jun 2011 21:21:05 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 5/7] KVM-GST: KVM Steal time accounting
Message-ID: <20110614012105.GG5341@mgebm.net>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
 <1308007897-17013-6-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0qt3EE9wi45a2ZFX"
Content-Disposition: inline
In-Reply-To: <1308007897-17013-6-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0qt3EE9wi45a2ZFX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jun 2011, Glauber Costa wrote:

> This patch accounts steal time time in kernel/sched.
> I kept it from last proposal, because I still see advantages
> in it: Doing it here will give us easier access from scheduler
> variables such as the cpu rq. The next patch shows an example of
> usage for it.
>=20
> Since functions like account_idle_time() can be called from
> multiple places, not only account_process_tick(), steal time
> grabbing is repeated in each account function separatedely.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--0qt3EE9wi45a2ZFX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9reBAAoJEH65iIruGRnNOj8H/1r7tlTJxe3UpqpRaelcMA9G
Jvz8wli10Zx3cAMti2a9qYm6KWiudWt/nDN5sNgCT1mFgj8/FbSoLz5kMH/DTtoA
932rT0Cj7JhcjRqIxcITM+sEXcfOkEykCbi9zsoAGrTvGT8+I6c/xuc9dBcGV1If
jBF6zk690HNudBxL1bNvdoPg+rPlvxVYMURWLW2+D/c22QLvyFUbk7V4BVnstVz0
8C7+u9sb3iZmNQwWQwpx29DOan1AOfSQgddTgaY81Xq3f0cNv+Rl3qbgTGqWBdum
qwQDL6SUaHYlVPxH2I3ULNYigLWwx/Gg9Jj+g6AMVsVeVHaporAWtG50gQ26n+Q=
=d2Wx
-----END PGP SIGNATURE-----

--0qt3EE9wi45a2ZFX--
