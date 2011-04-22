Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1DVNGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:06:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab1DVNGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:06:45 -0400
Message-ID: <4DB17D5B.2090303@redhat.com>
Date: Fri, 22 Apr 2011 07:06:35 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.9
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@toxicpanda.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Coreutils <coreutils@gnu.org>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de>
In-Reply-To: <20110422112852.GB1627@x4.trippels.de>
X-Enigmail-Version: 1.1.2
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig3440113740B5193E68F3D547"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3440113740B5193E68F3D547
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/22/2011 05:28 AM, Markus Trippelsdorf wrote:
>> I would be surprised if the bug is around for such a long time, but
>> otherwise I concur.
>=20
> It's a bug. Let me quote what Jeff Bonwick wrote on his blog:
>=20
> =BBI'm not sure where you got the impression that either SEEK_HOLE or
> SEEK_DATA doesn't set the file pointer. They do. (If they didn't, that
> would be weird, and we'd call it out explicitly.)=AB
>=20
> http://blogs.sun.com/bonwick/entry/seek_hole_and_seek_data

I've created a request to standardize SEEK_HOLE and SEEK_DATA in the
next revision of POSIX; comments are welcome to make sure that everyone
is happy with wording:
http://austingroupbugs.net/view.php?id=3D415

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig3440113740B5193E68F3D547
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNsX1bAAoJEKeha0olJ0NqwNMH/RFHCct8i8aE8TKB3gvFAfMB
Mf+TiHebzAitBX6/FfdoWb1+MPPG4kNVXd8sjOyjHG/AfeqfCtUHr6gJ/kRbS17p
b8uuEaH4OO/see4Q4ghuSo/dELCthm1IVIwHg7TBF5LBsuFWI561GIgM+bRL0iPU
bt0SFrddLWEjZQaWxG/myZeQwzV1BHDr8p4S1K5TkKfw6D3K5XHW9hISWo/drBuW
haOLA7y26bupunEZrTuK9igS9vgcMrpnYui/Ly+/87c0Dn+eE04FtxHArsV4v66g
16o7NsBl8qIdXhGJiGOBg8CJouRDfOcPlLakbQXnAFPrjsoJeKRrd2iO7HlANk0=
=iKrP
-----END PGP SIGNATURE-----

--------------enig3440113740B5193E68F3D547--
