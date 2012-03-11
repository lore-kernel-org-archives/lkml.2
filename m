Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2CKUYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 16:24:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2CKUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 16:23:31 -0400
Message-ID: <1331497397.4641.87.camel@fourier>
Subject: Re: [PATCH 0/7 v3] Push file_update_time() into .page_mkwrite
From: Kamal Mostafa <kamal@canonical.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jaya Kumar <jayalk@intworks.biz>, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 11 Mar 2012 13:23:17 -0700
In-Reply-To: <1330959258-23211-1-git-send-email-jack@suse.cz>
References: <1330959258-23211-1-git-send-email-jack@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-uNr12NXa9pODOIjYE4wW"
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uNr12NXa9pODOIjYE4wW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-05 at 15:54 +0100, Jan Kara wrote:
> Hello,
>=20
>   to provide reliable support for filesystem freezing, filesystems need t=
o have
> complete control over when metadata is changed.  [...]

This patch set has been tested at Canonical along with the testing for
"[PATCH 00/19] Fix filesystem freezing deadlocks".

Please add the following endorsements for these patches (those actually
exercised by our test case):  1, 2, 6, 7

Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
       =20
 -Kamal


--=-uNr12NXa9pODOIjYE4wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPXQm1AAoJEHqwmdxYrXhZd2IP/RMP90PYnrdD+ssBVyMMl6dS
LVc6bKs+9M5OtXxt2UJ7CJ49EOupHhyj0X0ehEDCyJYIyBUHey2FAXa6/tgrRRy6
G/VeNr7TTYOyUDpvpaJRtjEoqXnqN/Q2ffyRMjaQQtItSGfFTkOP8ojiH4MXQYiD
lxD3Skcb87+QhiYDdba/w6BFQdc0hNotHdaAO6kEZZktdYgKpT802+zbJkl+gj3G
c47tac0AoSgs3iLxO0Q6RBHswAFIoACvJC5VbJk8sIRAsJ6uyfuqjfdRw6YPRooU
zojPVBQVAQAhBKZiN62LNDX90/+0eQ+VrCVCIRUZ8Bh9XIAgDxrU45pJ+o3MZ2dd
QKI9SbkYr6PnU7kz9X/ifrNt0cqRAErEK2w+tuq8aAKdcmjmFZ1IXL115yUJMRJr
0irkld8l3ZM8alJUVe5YIm2eEuxCQc9f+G+EJ220dwEWp9c8pGCWy7med9sqsyEN
jlBAuBQuzfpJ2jRiVnh2rXL7fs54wTSRe/3aM8M9LyMFiv9lAmbDGkwBfMu72UV3
l2pZ6q5zhViSiWwsD2dThdCY5BU6i90QUgB2H09jYZBWvKDKwklFid0ySQkkBfKI
zuK42hWY55Dqi6JNHwk0gQpts+aELPBSh39tnLETbCYahGkUamSgKk9wnYSB3XIl
RkMWQlxO36YoVCig3sCk
=g1ZX
-----END PGP SIGNATURE-----

--=-uNr12NXa9pODOIjYE4wW--

