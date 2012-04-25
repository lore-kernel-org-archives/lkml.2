Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2DYDV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 23:21:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab2DYDV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 23:21:28 -0400
Date: Wed, 25 Apr 2012 13:21:22 +1000
From: NeilBrown <neilb@suse.de>
To: Chris Jones <chrisjones@spin.net.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.1+ kernels unbootable
Message-ID: <20120425132122.11280b66@notabene.brown>
In-Reply-To: <20120425124925.267056b5@ubuntu>
References: <20120425124925.267056b5@ubuntu>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F1eM8Rjuk3sbMQY/fr4a2I3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/F1eM8Rjuk3sbMQY/fr4a2I3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 12:49:25 +1000 Chris Jones <chrisjones@spin.net.au> wro=
te:

> I understand this mailing list is not a support list. But I am curious
> as to what could make the Linux kernel non-bootable from 3.1+ kernels?

A bug probably.

>=20
> My 3.0 kernel boots just fine with my current system.

You might like to try=20
 a/ describing your current system in more detail.
 b/ describe what actually happens when you try to boot a 3.1+ kernel.
    It is rare that absolutely nothing happens.
    Also describe the provenance of these 3.1+ kernels (do you compile
    yourself, or get them from a distro or....)

NeilBrown

--Sig_/F1eM8Rjuk3sbMQY/fr4a2I3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5dtsjnsnt1WYoG5AQJe+Q/9HQfmFSjLa+EE1ajHAmKOap2j0xmTa0fl
ttOja+isa+Ve7XSocMB302LiG0U34h8On6E31KMWbvaj2FmhZPJWPwSz8qo/bQzH
2Gij3WMuunJ2JRBrwPJ+Zem32noIP7EL7MdqwbvG8HyOuRYRy7cLqWK9+Spa96qm
Dyw41iEJ7Q9kZW6JzozrO7EzlHtwOqxSodvqWfOHz0WcY58gQwtIgRSQEU94TNN+
Hg4IX0u0Wib4v+wZnvXosr787Lz7xVmTA5TTfM1CJiwfD8Q056La8kvlb7PCWfle
se/PXHaId91guzVwbK23ab40TCcWXl5FY0wbpASJ8z7qKj0fuzW625WVbsVF4AE1
dxslB6k1Pk7NhArwFKjK2coDk6jPD7Xrff7BzCa4UnPf+njisq/ThpkZ7LlAzRba
MvXA8AUSeQJTDucq6lypelGHJrTg8vW/6QCfc9+g/vS8PTkwf4vDmjZ0QsgJFO8/
AyLJZRzNByoIke4iYWFq+yd2yNtxnikxULA/wYMS/GYvEwWGuue9UahqcK6d+FBu
66uEZASkH/hJRLhPDh4YwgpFiNC+vnrB7g3WIY3u+pJ2rtqK/nH3EI71deNgWR1P
0vaVoSyrWQrOj/xObBB5dtBXrgHRoMexFan2CPGudq1NAQYBt52nUkTNazvw6og6
WgPldByI1lQ=
=ba0X
-----END PGP SIGNATURE-----

--Sig_/F1eM8Rjuk3sbMQY/fr4a2I3--
