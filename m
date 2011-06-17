Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab1FQAtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:49:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab1FQAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:49:15 -0400
Date: Thu, 16 Jun 2011 20:49:10 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v2 6/7] KVM-GST: adjust scheduler cpu power
Message-ID: <20110617004910.GG27252@mgebm.net>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-7-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzCohdixPhurzSK4"
Content-Disposition: inline
In-Reply-To: <1308262856-5779-7-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BzCohdixPhurzSK4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jun 2011, Glauber Costa wrote:

> This is a first proposal for using steal time information
> to influence the scheduler. There are a lot of optimizations
> and fine grained adjustments to be done, but it is working reasonably
> so far for me (mostly)
>=20
> With this patch (and some host pinnings to demonstrate the situation),
> two vcpus with very different steal time (Say 80 % vs 1 %) will not get
> an even distribution of processes. This is a situation that can naturally
> arise, specially in overcommited scenarios. Previosly, the guest scheduler
> would wrongly think that all cpus have the same ability to run processes,
> lowering the overall throughput.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--BzCohdixPhurzSK4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+qSGAAoJEH65iIruGRnNNHIIALHZMVPYigIgoe4ln/JeVM7A
FPHPw5CgxzK446kxvg39dKB1rvVtHScIQrYbPS4QI+fKLP4hi/cx3nF+7DvhKtZr
cwKsuuU780IGBApQuM5u/XgpCnI4GB177cGjNmB4MWmtvH9oA5LuM7uyycp0YPTw
7q01B2aNisJ5HQ4LoCWyNSORE0JzzQbNtA7CobzBjmDHrD0kNb1ggbDhGYtq1s9G
OwdiisJWpc1hynuj3Km3Yvl5n7eh0D0LZdLTS0KSEnzAfZGfEkuXHzFFLz+Xgj5X
j6oywo3gk2JFGbR1sZn4VMjh1PvEuTEH0asz4vbzgNjffKDnbaUUYFco+wGmAvk=
=fpTs
-----END PGP SIGNATURE-----

--BzCohdixPhurzSK4--
