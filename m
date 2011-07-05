Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab1GETgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:36:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52078 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1GETgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:36:11 -0400
Date: Tue, 5 Jul 2011 15:36:06 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 2/9] KVM-HDR Add constant to represent KVM MSRs
 enabled bit
Message-ID: <20110705193606.GB3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-3-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-3-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> This patch is simple, put in a different commit so it can be more easily
> shared between guest and hypervisor. It just defines a named constant
> to indicate the enable bit for KVM-specific MSRs.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2emAAoJEH65iIruGRnNIx4IAK3wnccn5ANt74NA38l8Kh8R
KjeORnhkZZkZUMLc6I4/XPLl59jFYyZZpJuNUnEa/msVkE+h2CpLPNRvSgFvLz/4
sHboZuXHLLUbdC6VzOI3awO1DgepVNsVUC9zBiTRV9d5295ndgxFDEfA1DK2Twj5
rZKNYawknuyK8dKWDUS099le/cYk/gRqOxCaaQPmmJu3YaWqyecFHSUneI65MTGQ
oTBdu4+O9VmXieCsnY/rRsejuvZX16C764Lqh7VOtHllXub1sBvgKaz1CUllD5Gg
F9TAE590uWlV1EfJuQqfzIte07FkPcMvtvKbwgBJidqptNkR3SmZwvKUgsZfJNA=
=RgLw
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
