Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab1FQAtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:49:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab1FQAt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:49:27 -0400
Date: Thu, 16 Jun 2011 20:49:24 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v2 7/7] KVM-GST: KVM Steal time registration
Message-ID: <20110617004924.GH27252@mgebm.net>
References: <1308262856-5779-1-git-send-email-glommer@redhat.com>
 <1308262856-5779-8-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dx9iWuMxHO1cCoFc"
Content-Disposition: inline
In-Reply-To: <1308262856-5779-8-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dx9iWuMxHO1cCoFc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jun 2011, Glauber Costa wrote:

> Register steal time within KVM. Everytime we sample the steal time
> information, we update a local variable that tells what was the
> last time read. We then account the difference.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--Dx9iWuMxHO1cCoFc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+qSUAAoJEH65iIruGRnNbfYH/i4ZruC9ZBMdMy18NBf3mi6N
Lt6xWF2M9jSohbPyI5wYlaM+MnXPYkVAf5BR3JbDRc/FEhDU+D93y3jUmSZ8SXb5
rJsgwozgraJxguWVagTASsbSb4ZqcNxmqvFMZU4AAQb/BcbMyHx3N8iehaxBoxcW
l70ehi0kFGa/A5sUpUGcnpj7poNtYlF5bAHlWeH0h9KVYnTWFCCVET8gPsken2eW
iOJqwnGUnYr4cMLfHtytx5smo+oVU2lsianOYtTiFvXW+hO7lMAxedLUjL4kLQB1
IW5P3f/Zg5bn+iifReZ7DscsZpxvQAfGwOVTskWDgYQRr0SGbJ4nXlOBQsRoreU=
=ashd
-----END PGP SIGNATURE-----

--Dx9iWuMxHO1cCoFc--
