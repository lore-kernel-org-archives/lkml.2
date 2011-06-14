Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1FNBTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:19:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44147 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1FNBTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:19:03 -0400
Date: Mon, 13 Jun 2011 21:18:58 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 1/7] KVM-HDR Add constant to represent KVM MSRs enabled
 bit
Message-ID: <20110614011858.GC5341@mgebm.net>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
 <1308007897-17013-2-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1308007897-17013-2-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jun 2011, Glauber Costa wrote:

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

Acked-by: Eric B Munson <emunson@mgebm.net>


--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9rcCAAoJEH65iIruGRnNyM4H/1Wc5ZxJUx2iXKSC/EeR9x+u
+88pyid2nIMksDhshFn/IEqHt8gSR+u0/S0VtDtzxNPzimjqiNKlC+EeplzRoxoa
g3TrcsaBbo9me0VesUOZa0OxGU5kLLii6WqNMV5g1xe9AnPAcNeSg6mh1Se/iODJ
86RfC2znCMALra9N+c7TTL60OBUYv8pOTtAuqddqMJjdaD3SQUgSR91q6aivBIX8
j4GPzdNpQH6Npi5WOAbqd04GQrawlkWVGF6j9twz/piryov/qj+6s+gdJ5ih0rvT
334m6MIaU6oFns4Q3EiEw1aL2/6Yewif2ULpTOddocIgvq7QwO1ZR2RPM2zSc+w=
=EPAv
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
