Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0LONV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:21:58 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40704 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab0LONV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:21:57 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.37-rc5: well done, thanks!
Date: Wed, 15 Dec 2010 14:21:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-tp42; KDE/4.5.3; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1817730.HxLKfM1dZp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012151421.53800.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1817730.HxLKfM1dZp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi!

I think when I complain about kernel quality its also important to say,=20
when I perceive it got better again[1].

Well it has. I am especially fond of 2.6.37-rc5[2] cause it even got=20
noticably faster on my laptop - likely related to the tighter integration=20
of Ext4 into the block layer and the replacement of barriers by Cache/FUA=20
requests. Tab completion under I/O load has gotten noticably faster.

But more important the reported bugs I mentioned are fixed:

=2D bug 15969 by Jerome Glisse
=2D bug 15788 by Alan Stern

Alex Deucher fixed the radeon DRM/KMS freeze bug #16376 which was the tip=20
on the ice berg. I didn't even report back then cause I didn't have much=20
to report other than that it freezes randomly. I bisected it down to about=
=20
10 revisions while some other guys did it on a freedesktop bug report[3].

There are some issues here and there, I reported them. I asked what to do=20
if reports receive no reaction and started bringing up some here on the=20
kernel mailing list. I think I will ping some more specific mailing lists=20
for some of them as I tend to believe that bugzilla is a good way to track=
=20
issues, but not a good way to contact the right people about them,=20
especially as it does only accept mail addresses of bugzilla account=20
owners in the Cc field and the default assignee may not always be up to=20
date. I will to ask about and resolve this on a per bug report base.

But overall I am quite happy with the current state of affairs.

And before someone mentions it: I know its subjective perception (which is=
=20
what matters for my usage of Linux).

[1] http://lkml.org/lkml/2010/7/11/17

[2] Yes, I compile and test rc kernels now ;)

[3] https://bugs.freedesktop.org/show_bug.cgi?id=3D28402

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1817730.HxLKfM1dZp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk0IwOUACgkQmRvqrKWZhMdIqQCeLMqkcBhCEUooT3jvFmOe+c+O
+GYAn1QxCiQdmJbg4nnQjReTOWmY7Oon
=Upm8
-----END PGP SIGNATURE-----

--nextPart1817730.HxLKfM1dZp--
