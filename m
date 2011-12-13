Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1LMQ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:26:43 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47855 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1LMQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:26:39 -0500
Date: Wed, 14 Dec 2011 03:26:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [GIT PULL] User API split: Preliminary patches
Message-Id: <20111214032627.8375a7d088e575dce85e6b2c@canb.auug.org.au>
In-Reply-To: <21378.1323792574@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
	<21378.1323792574@redhat.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Dec_2011_03_26_27_+1100_Hj9URw.Um9KPSUiI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Dec_2011_03_26_27_+1100_Hj9URw.Um9KPSUiI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 13 Dec 2011 16:09:34 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> David Howells <dhowells@redhat.com> wrote:
>=20
> > Can you pull the following into linux-next, please?
>=20
> I've made a 'for-next' branch for you to pull if you will:
>=20
> 	http://git.infradead.org/users/dhowells/linux-headers.git

(I actually used git://...)

> branch:
>=20
> 	for-next

I will add this from tomorrow.  This first part looks mostly
uncontroversial, but the next part is more intrusive ... I have not been
particularly following the discussion, so I do not know what level of
acceptance these changes have.  i.e. comments from others would be nice.

> and altered the comment on the patchkey patch that you pointed out (that'=
s the
> only change to the contents).

Thanks.

> Additionally, I've stuck date names in the tags.

Good idea.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__14_Dec_2011_03_26_27_+1100_Hj9URw.Um9KPSUiI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO53yzAAoJEECxmPOUX5FEqGQP/AwL4o+8VPPVfQDl3V1PzUQj
wNKG30S9C2cfv7Zlv0VhRaHpYq7RudTGYzB2+itb5uZ9B4sSoHeGo7fiKqY03YoP
oHPd2IyT3vW8an4X0wfDrOQrK3EtpVfGmlQHsw8+4h5dGaTzRwIfxnIQKqt3eRxa
pnm1HSaaJLNoFRWqrbA2SeuK0H8vNaUj2t4MV1BTEQXzZZ0h66wlbl6J9sQ/bZYR
FNV5UJWtmPAtg1KtERwRg1ws1YQ6IJEk1JEX9vZoBVj4Vx3xckwHJdcjIPdxB+gi
yHzP8fIqKDx4tQ6uoazYGSV/xzUY6phnyWQ3pDwBpeIbPhiBr0HHf1NtPP9iAOTX
SrraBUaoyE42ZKx8GLBMRn8qB24ODt+OyLXIGhkBVmV4Juf5h7uD4/YQSc43sOnM
/Mo5NkJCRv7lM1BJkTgArD63mnQclJZgFsJv+vMruNgAZBGSE8yFJq95/0tsZxkC
CSFyhgpzuXpar9KjOqkNNMbX0sqQBUThoN+uYKkCi0hbBWh+emAHKGKtUjFdjwsR
mUFlAPosNgj3pDMl3/zd90Rks7d6cAjthNrMOs7EBWPovwc+gy3oSdy7/RveJM5y
4BPqhtpFvQXqKZLioy92EtpZxjyPQcbGNyEwsZSqaI3b0BHxTZo8Jn9DuBWaQNAm
IuLa2J5km3m6y0tqdrZF
=H82f
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Dec_2011_03_26_27_+1100_Hj9URw.Um9KPSUiI--
