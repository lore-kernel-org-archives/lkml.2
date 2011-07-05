Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1GEThd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:37:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56957 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab1GETh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:37:28 -0400
Date: Tue, 5 Jul 2011 15:37:24 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 9/9] KVM-GST: KVM Steal time registration
Message-ID: <20110705193724.GI3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-10-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-10-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> This patch implements the kvm bits of the steal time infrastructure.
> The most important part of it, is the steal time clock. It is an
> continuous clock that shows the accumulated amount of steal time
> since vcpu creation. It is supposed to survive cpu offlining/onlining.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2f0AAoJEH65iIruGRnNnosIAJxqUiofBSh45Jm9ZZ+I6RUF
z/4xJjJTeH11dkfsRinXgI0n+e2m5Kn79OqRjxyegO0dyKkQckHcj3tXYBbYTsmY
eNFE5VoroFcGvlzYvwgLsxVuS5+C3Eva4Vz57UWR+73s7J8KYLsUCNmMYPqaePhq
wdzfybqwBEzRs90SyRG+F4lu6qaBJMD8YNBdX7oUnIdMaqXC69NuZDI0qIIqOSiu
kVKFhKdQ8GgxGoym5xPwIgIfACAkTrrSpfCWxEfaqaQnHP3iY8Ps9C6JwCl1tlpu
ZvwuOXnBUQ7eMviyRXbti/cXX6spltc1iMGb9cTtPodRhkZNvQhVjUCEpdH8UwA=
=BbO+
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--
