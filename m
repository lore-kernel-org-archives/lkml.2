Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2GNEKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 00:10:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49719 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2GNEKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 00:10:07 -0400
Message-ID: <1342238669.3209.4.camel@brekeke>
Subject: Re: [PATCH 0/3] fs/sysv: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sat, 14 Jul 2012 07:04:29 +0300
In-Reply-To: <20120713144244.f3c9fb27.akpm@linux-foundation.org>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
	 <1342103878.18274.98.camel@sauron.fi.intel.com>
	 <20120713144244.f3c9fb27.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YnAYaTqW8MuEUCgZbb6V"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YnAYaTqW8MuEUCgZbb6V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-07-13 at 14:42 -0700, Andrew Morton wrote:
>=20
> The issue Alan raised around the superblock timestamp is still up in
> the air.  I guess he's a slow typist ;)
>=20
> My take is "no, we don't need to do that any more" - surely all Linux
> systems have a functional hardware clock.  But the changelog should be
> updated to describe and justify the decision.
>=20
While I do trust such system existed and may be even still exist, I
doubt that Linux sysv FS implementation is of any help for them because
it updates the superblock time-stamp _only_ if there was write activity,
otherwise it does not. So you cannot rely on our time-stamps at all
anyway. My patches just make it update the time-stamp more rarely.

--=20
Best Regards,
Artem Bityutskiy

--=-YnAYaTqW8MuEUCgZbb6V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQAO/NAAoJECmIfjd9wqK0i04QALvxeEhmK7eXV6PuKhHmSPdC
yAFhuQiEzyN5P7TWHBJsZSMLqZzI+oqvhqBYB7I6a6CvSLnA3v+/WiKrYue5ULDN
kZGXTLfQoB+5/U1p2jWlSOPBfMafk6cPqW3KLmQqQPtGiQ8mQvsPKLn67c88IiD6
+3aWV02jgP9u3VA4hGC5COJU5VIroZPZvHOzT9XdPQqpoNYJCD1nZg3RON6OvCfk
EmN3Z4n716Un/5Zu3hVsWo+an2rL89qLZ3fm7tzpVeBBID11V+KRjc4gdONm5L7h
gij0GreqMlR/k4q/lBMTVA0kYoMXO1W4riKG8Q5BCQ0r2pZCIIEaAMXcVBXXilyD
O8ZtVzt/geCPoKdAItOw4BE5RImAgSCY6Q+RsS6EDmlH0h/s2mgFnnlsAMxjjLsx
xJUZ5ESxOm5LH10HeNpmpcXoG+PomxoIozLvSFw9rMzygK/2vFzkrFzABEX+o1SB
fvBkdXUNs5Qd8Z4irCs8rZJz+Teu3HtpKLRpO2aaCzV4ouL6LmW2Gez8Hp/KlrF/
9ZOkCHyHLH8abYULaOJziaU8sY8Mqb4rfupKeG2KneQjAuJNBdXWei64dBxrl1gF
y1VCSzzzeqDRdPk4P+CgSWXnQZ2J4TOWbmWI5EyXnUHWHWyruG6XIoBQwFcaMjPr
J3HL2lw5PxJOWkb+tkVY
=yxcZ
-----END PGP SIGNATURE-----

--=-YnAYaTqW8MuEUCgZbb6V--

