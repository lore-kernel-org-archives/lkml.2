Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1FQAr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:47:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43851 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1FQAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:47:58 -0400
Date: Thu, 16 Jun 2011 20:47:52 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v2 1/7] KVM-HDR Add constant to represent KVM MSRs
 enabled bit
Message-ID: <20110617004752.GB27252@mgebm.net>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-2-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <1308262856-5779-2-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jun 2011, Glauber Costa wrote:

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

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+qQ4AAoJEH65iIruGRnNqjcH/2ut9D4AAH4b0bSQCOINgGN4
e1zWqGKI4QcoFgVFDIMWH0yRxu2rT3iXVMfiWT1yki7jZMpiXN5axy3ml+ADE+VU
Amk1juK2dOMiEX2UUt5T7DWVH7+6cWvRmF0Q0Xa9heOyVsUU4tMOGoBVcoLDoIxD
XQECAdK+b9wy4f/FlzGInDK9fekbR9oPwW2yIFVviK881+R0teuBIoQOtHbLIO2p
9zcAotzakcGHUaIIaCvrnPyaS8kq1gL3602KHarexSd42fch9pPTgSlzB6/sHjZ0
0mbBxa4EokLeQWkZDuyV4eLqdGZKIPeRfzEvCEk88ka1ib0Dn5Uo/C7ondJe/NQ=
=2U9p
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
