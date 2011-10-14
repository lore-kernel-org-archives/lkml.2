Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab1JNPV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:21:28 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42210 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933159Ab1JNPV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:21:26 -0400
X-Sasl-enc: sbyuixmymZJOHqP/GiLfKH/K69IuWwWCjIA/1VYhHo+/ 1318605685
Date: Fri, 14 Oct 2011 09:21:00 -0600
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Answers to some common kernel.org account questions
Message-ID: <20111014152100.GA11717@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

We (the kernel.org team) have noticed a fair amount of confusion about
the procedure for the reinstatement of kernel.org accounts.  In an
attempt to clarify the situation, we have put together the following FAQ
file.

WHAT ARE WE DOING AT THIS TIME?

The first priority for kernel.org is to get the git trees back on line
so that subsystem maintainers can publish their patch streams and get
them into the mainline.  Other functionalities, such as email and file
uploads, will be restored later, as time allows.

WHO IS ELIGIBLE FOR A KERNEL.ORG ACCOUNT?

At this time, we are only providing access to developers who previously
hosted git repositories on kernel.org, and whose repositories have shown
activity after February, 2011.  At a later time we will be able to
consider creating accounts for developers with inactive trees or who
have not had a kernel.org account in the past.

DO I NEED A KERNEL.ORG ACCOUNT?

Possession of a kernel.org account is *not* necessary for contributors
to the Linux kernel.  As always, changes can be contributed through
trees hosted elsewhere, by direct posting of patches to a relevant
mailing list, or through a subsystem maintainer's tree.

WHY DO I NEED A PGP KEY?

A properly-signed PGP key is required to obtain access to kernel.org.
The purpose of this key is not to replace the trust that we have built
in each other over years of collaborative work; it is, instead, a way of
safely passing credentials in a world where the community has simply
grown too large for us all to know each other.

WHAT IS A PROPERLY-SIGNED KEY?

Anybody can create a PGP key in anybody's name.  To avoid forgery of
keys, we require that keys used for access to kernel.org be a part of
the kernel's ring of trust.  Joining the ring of trust is done by having
your key signed by other, well-known developer keys.  So we encourage
you to obtain as many signatures as you can reasonably obtain=A0on your
key from fellow kernel developers at upcoming conferences or developer
meetups.

Specific geographically-isolated developers who are unable to obtain the
requisite signatures will be considered for access on a case-by-case
basis.

WHAT ABOUT FILE UPLOADS?

The "robot signing" of uploaded files that was used in the past is no
longer considered to be sufficiently secure, so a new policy has been
instituted.  A new tool ("kup") has been developed to help with the
implementation of that policy; it works in a manner similar to the
upload system used by the Debian project.

The kup tool will require developers to sign files with their PGP key
prior to uploading to kernel.org.  This mechanism will keep the private
signing keys from ever being stored on kernel.org (or any other server).
More information will be made available once the file upload capability
is restored.


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOmFNcAAoJEDjbvchgkmk+8HYP/i9Q+T9rX9Y/U/YOZj99yFX5
7ddixO2/aSWtOyasCZww0/cvTUwCSWRVfVjqz1EikrejvBQAJ0N6Lve/OqceB9cm
30DmXjaPQWkgapPmUhPe8/79APNE0Hy2HfH2JLdhy+/lRw9KGwdkpGEbmU1om8f8
CSO8ApIQDuONFOB/vAt4DUytMEnEEe/mH0HaBIe1C7ox7/LHeXxCZeLwB1xfA/8P
D3xqyIdw2iVb5mwnHheQDdkJwviZ8i6XzQqHYMuJ2wlWuS3HwgDl61kb2IG7JYM0
D2NWPM4uSPRCLWea4wSTG6+yAnBn2UmOWQx9HJ8Rry4k9sEqgzoc5IfhKdb43ry8
S/VTYfMVdHYZpnyIJnpH84zMpn355ERi/NzD2s1vK2/oC9Qlu/03EySuRoBbwBlN
VyQuLEZ+GMT6Iod74fr0fcVLjmtll9sTbiWoy0fbEQ1wl0O3NMo48a3u/WsYp/+E
4F09vfH8DMKCU+DTzYIu5KpHuBFj9V0favWZXyHEmZ4B21uPnzSjCfBcjwJETciQ
SmfpvgLxYMPeP4/Kaic8sraX34bTLdRkwm8xwFpz6xNnhs5lRi0hZWpX58/Ko+x1
VNBBqoKRjN/Rv5cPd3bL/ZKz24As8aVzDNrtf5KQgIFui6IqvBNcSz+YGtCnf43G
ht2gCTzQxbNEeZTn6TDZ
=TATR
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
