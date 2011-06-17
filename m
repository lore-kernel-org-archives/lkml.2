Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab1FQAtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:49:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab1FQAtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:49:02 -0400
Date: Thu, 16 Jun 2011 20:48:59 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v2 5/7] KVM-GST: KVM Steal time accounting
Message-ID: <20110617004859.GF27252@mgebm.net>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-6-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bqc0IY4JZZt50bUr"
Content-Disposition: inline
In-Reply-To: <1308262856-5779-6-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bqc0IY4JZZt50bUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jun 2011, Glauber Costa wrote:

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

--Bqc0IY4JZZt50bUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+qR7AAoJEH65iIruGRnNpHwIAMFEd0PMSWyPS+2qjV33aOHF
2Z7atLy2MQ9j+xMwE2iACabW6f8GVwVyvxsEIp/jub/6h5ZYlE4uFEFHbbu/p7TW
/1xZfidVl3R8tLCjYco2EFGhQei2jttc5pqxx0YEJ9Oxutj190z4MsKptXbP1g3w
ARo7b1cNqXOhMSCrWvXlyjeHQDYhaOILu4Fg4aObvO85hvz01EorHekjQZmT3r8k
0bkjPEpVyWGxDjOCd8MaAy353YPocutIEo+N67dBqrR9cCxj43EC1wkYs/Voy2yn
Hu1aoxinhss4NTPLY5EhvNH5VUd0TavDm0lXJcsQDVS4Rriw7VWkRBsYjxhnB5A=
=v0wW
-----END PGP SIGNATURE-----

--Bqc0IY4JZZt50bUr--
