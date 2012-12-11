Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2LKWUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:20:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37545 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2LKWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:20:32 -0500
Date: Wed, 12 Dec 2012 09:19:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kees Cook <keescook@google.com>
Subject: Re: linux-next: recent rebases
Message-Id: <20121212091945.5ae4dab6e6716fdb4239201e@canb.auug.org.au>
In-Reply-To: <1355263123.3527.27.camel@localhost>
References: <20121212084108.de14154ec0e365453617bfd7@canb.auug.org.au>
	<1355263123.3527.27.camel@localhost>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Dec_2012_09_19_45_+1100_7nJRVQJJBvfcCY+."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Dec_2012_09_19_45_+1100_7nJRVQJJBvfcCY+.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, 11 Dec 2012 16:58:43 -0500 Eric Paris <eparis@redhat.com> wrote:
>
> On Wed, 2012-12-12 at 08:41 +1100, Stephen Rothwell wrote:
> >=20
> > fsnotify: rebased to v3.6(!) to resolve a conflict.
> > 	git://git.infradead.org/users/eparis/notify.git#for-next
>=20
> I planned to let it sit in -next until at least next thursday before I
> sent a pull request.  Thought that fit within the rules...

No worries, just noting.  Though you could have just done a merge against
v3.6 with an explanation in the merge changelog of why it was done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Dec_2012_09_19_45_+1100_7nJRVQJJBvfcCY+.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQx7GBAAoJEECxmPOUX5FEjnEP/0eNHq5Rd6URbpGNDY4I33B+
Yqzz451VuZD+v2HW4cvE0EH8L5y7hkyPqc8PJg7/oZdtOcK2nVlD/HxYqntSi6+M
5wm5yBhS/MpmD1gpaQAR8P/1BL8qOtZhraCMZHqxcwoKXrlmEIJ5lbzy6hrj6ZHk
BMxsm4GxwZKJuQFGLvJGS0CKgWorH5FIkSLsqBCFvjVgbuAOMiohegBHNXqqryty
yQiiCsWB3JpvzmU2TGMDnavlovv/4QRXmtpUfk2N4vwsVjqVejCqzOF7g0+IXjUk
gbl+oqwL+TTRQbXapR4kIjyxUuqliIAipDJlWzpWh084egGk85mzSs+s+jdPZWRl
PSZH625G4rL59bILBvBSsq5+0jD9OwKnL7VnSalQXxdZ4U2ohAGbhn8eW7i8vb4d
Y4b/XtRKhrpbzKVfKOnMAUUykjqd88XxtOBLX/A5YqEuciOiR2KQvLfhJ02AySKV
TQxKUx2c4HcJHpOz50UAVL8FPGGi813rT7icL0UppcpeiDOk2iJEviwNRotebObt
uZpLrgUUac+Muu16LZ1uzBL6AzVz93eIo4c3LsFM0h4Asw+UDLcjM5CL67qAabr4
8pU9MOYiAq5nlnvZyqWzNPUyJJdFup9VUjkZNzP4rKbQ7/iXg97bZisN1BVj+s1l
IA2cmsQlPKm7A8Sv6FL/
=WCGl
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Dec_2012_09_19_45_+1100_7nJRVQJJBvfcCY+.--
