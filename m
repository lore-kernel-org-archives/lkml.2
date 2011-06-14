Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab1FNBVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:21:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47243 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1FNBVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:21:02 -0400
Date: Mon, 13 Jun 2011 21:20:53 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 4/7] KVM-GST: Add a pv_ops stub for steal time
Message-ID: <20110614012052.GF5341@mgebm.net>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
 <1308007897-17013-5-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0hHDr/TIsw4o3iPK"
Content-Disposition: inline
In-Reply-To: <1308007897-17013-5-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0hHDr/TIsw4o3iPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jun 2011, Glauber Costa wrote:

> This patch adds a function pointer in one of the many paravirt_ops
> structs, to allow guests to register a steal time function.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--0hHDr/TIsw4o3iPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9rd0AAoJEH65iIruGRnNj2oIAMEYvct0vlJ+5kL/BmY2F3Ea
DCk1yPPS9rohAqNQHu+aB6qpV958FvZAbQZD5vNY0iImnRudxIRzagJTWrQfCif4
zVaT/5tiF1LBPIxfh9GHA3XXbvgjIxQvRlajesmzhiwjFvOpDRuY4QPnSiywd0Zy
Eicu7YZMmT6WPPm5aW08iy5ff3SM4en5tDTxsWZjB9X49b8GpUEqYigUFIioO3Ri
8bEb5AZ+pVe9MFkm7If+nbc1sXmG2JDLKDa48V04VaRwu0i9XKT/RMzDt3hZq6EF
ZIFNU5I3hhLeuu8pV2aiFiGwi2EiOwuuQoMaNWmb+RcO182GLknM9KM8Aw5X6FQ=
=Edr4
-----END PGP SIGNATURE-----

--0hHDr/TIsw4o3iPK--
