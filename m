Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1GETgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:36:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58121 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab1GETgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:36:47 -0400
Date: Tue, 5 Jul 2011 15:36:43 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 5/9] KVM-GST: Add a pv_ops stub for steal time
Message-ID: <20110705193643.GE3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-6-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-6-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> This patch adds a function pointer in one of the many paravirt_ops
> structs, to allow guests to register a steal time function. Besides
> a steal time function, we also declare two jump_labels. They will be
> used to allow the steal time code to be easily bypassed when not
> in use.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2fLAAoJEH65iIruGRnNjJ4H/1eoBeBk2b+j83cgAOhv053y
h8zlUWedtAQg2Rje9qc3o/0KtxxjFl8nOvJ/2nujOG4NQkl3fxV8AePNczTA0geu
wAi6tCkl8olzLGMUEN2tu3Ek/hyj8+bkVpZ/K3tDXUNqtYF9Cj2StBJv7ciUexlQ
j2xXsh1YxOmJZhKyTF71l2Hm9z3UGgHFf3G51T0nv7ufiFiUAkWU0M/4x8pO09uR
kKNA4GEy1/1ABPsrSKEm9XepnFwlbfIcrxkBlCLo7Z8h7rEDxDwB/Dgcdf4XYnyT
F8E+1VAhcATcGd8kojHaY2ZFbEnSjcgCb3+WlU7OLdCiy3YmR6nVXN8wy8r/J7U=
=rzYE
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
