Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1F2V5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:57:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57157 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1F2V5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:57:05 -0400
Date: Wed, 29 Jun 2011 17:57:01 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
Message-ID: <20110629215701.GF3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-8-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-8-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jun 2011, Glauber Costa wrote:

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


--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC5+tAAoJEH65iIruGRnNmOYH/05Wamklkf1PSIFcimUKyYpv
zuMZuF6JiN8OO2pNOmjU/Axxo4GFV0qZ5uEK7isi4+tuj16emSymE6/+x8ELWPjZ
2oNVuSGJ+4pulvNHcg5lyWhGwa87hlrFSXcXLz98nXos75BJAmB5XbqwSIuz0DR4
23yq1C4CdDDwMYpXcbTq/izlozhnsrs+8gF9A/QggqRROyA+YDhr+hAfMrKsMSGS
hv/BEzJPVn59Del2axjBJKI+t6+alv8QqcKY8cc9Dw+PXzQMLt7LLgC1R6esY4Pp
j0JooHNYZwxpWouzwUS2i/EtryHoglm7sFfSXuMHxKH7VYnPGXFMQ5smhMFYTII=
=6nsI
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
