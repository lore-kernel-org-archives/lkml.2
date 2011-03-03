Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1CCCbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:31:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59537 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab1CCCbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:31:06 -0500
Date: Thu, 3 Mar 2011 13:30:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-03-02-16-52 uploaded
Message-Id: <20110303133055.db60038b.sfr@canb.auug.org.au>
In-Reply-To: <20110302181711.2399cdba.akpm@linux-foundation.org>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
	<20110303130538.3e99f952.sfr@canb.auug.org.au>
	<20110302181711.2399cdba.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Mar_2011_13_30_55_+1100_l8HoQFifYTbNevkY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Mar_2011_13_30_55_+1100_l8HoQFifYTbNevkY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 2 Mar 2011 18:17:11 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> What's in the 8000 lines?

Just the localversion-next file and the stuff in the "Next" directory ...
meta information about the linux-next tree.

> Didn't understand that - why is git-am unhappy?  Your sentence was
> truncated.

It didn't recognise the patch format since it wants an email-like patch
(with a From line to show the author).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Mar_2011_13_30_55_+1100_l8HoQFifYTbNevkY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbv1fAAoJEDMEi1NhKgbsR2kH/0prVyROTO7hUdnJ5mv1CcPJ
A4WrZOAaIvZIWkcjaVPtVmkWihGnx0e0jLEb8kSR9kyNUjHXkY4LbHvkAnLChwxb
ZoREL61FSg1H5M3lu7P79yI+MNhgie8X/eSBvapXm47kE9Aox9VbueTv1fN38abg
grvr/K5aA2SVvm1gsS8pAdbHONHF+RHj08i1wsAWZtdpjUNkq4B/OZGYQpGx8PBh
DLohDcNkuStZcY2C366Pe6fBv70GVIE4cR7qW0KNtwx/tYUYXzFQHq/YtQMYX5mO
cLD4drg2LSEZ1ItgkQ+i22bnFRN5/C5UdRg3DFjxlSUp8HLm1YvcSZjGE/vczNs=
=kPZM
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Mar_2011_13_30_55_+1100_l8HoQFifYTbNevkY--
