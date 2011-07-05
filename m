Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1GETgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:36:03 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63138 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1GETgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:36:00 -0400
Date: Tue, 5 Jul 2011 15:35:57 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v5 1/9] introduce kvm_read_guest_cached
Message-ID: <20110705193556.GA3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-2-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-2-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> From: Gleb Natapov <gleb@redhat.com>
>=20
> Introduce kvm_read_guest_cached() function in addition to write one we
> already have.
>=20
> [ by glauber: export function signature in kvm header ]
>=20
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> Signed-off-by: Glauber Costa <glommer@redhat.com>

Tested-by: Eric B Munson <emunson@mgebm.net>


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2ecAAoJEH65iIruGRnNd0EIAI2X/5uWHLY+MQ2mtPGBkNFt
IHC65GR6yo2EDrwxQIQnd+F7K9KCwxR2XyeRNgeDyO+bYEI7vihS+ogjffJUQtcI
lPr3EFEEzn8/esgy5jXkjqRCDMj+TkQ3f6ugxFJQRlAmhzPrNsQC5wo1eC5vemLM
QnFb4cfWtftbxhNK9Tjvrqu81IHJOhkkvlpO/HBKTzCgJDWWP5xkykR0KWC5LBB9
hNa7uLEYK8VZpjc1NmkHwcNuf9eDoXA7WBWQrrEI7o8k430cplvYxIq5XX5hmJW4
TQwEK2VjBXUVMXQJh6KdT5THPO4IWSZ/YyaIDzH8vPI+WJFmwMD75Rjuw0DmHVI=
=wWPr
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
