Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0EXFfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 01:35:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54210 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0EXFfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 01:35:21 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] NOMMU: add [stack] label to per-process maps output
Date: Mon, 24 May 2010 01:35:12 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.34; KDE/4.4.3; x86_64; ; )
Cc: uclinux-dev@uclinux.org, David McCullough <davidm@snapgear.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1261406150-7543-1-git-send-email-vapier@gentoo.org> <20419.1260982769@redhat.com> <19310.1261497490@redhat.com>
In-Reply-To: <19310.1261497490@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2383061.Y6vExabAUO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201005240135.14259.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2383061.Y6vExabAUO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 22 December 2009 10:58:10 David Howells wrote:
> Okay.  I've adjusted the desciption of the patch a little (see attached).
>=20
> David
> ---
> From: Mike Frysinger <vapier@gentoo.org>
> Subject: [PATCH] NOMMU: Add '[stack]' label to /proc/pid/maps output
>=20
> Add support to the NOMMU /proc/pid/maps file to show which mapping is the
> stack of the original thread after execve.  This is largely based on the
> MMU code. Subsidiary thread stacks are not indicated.

was there something holding this back from being merged ?
=2Dmike

--nextPart2383061.Y6vExabAUO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iQIcBAABAgAGBQJL+hASAAoJEEFjO5/oN/WBqfQP/3DEBFlpySEu5xLkBCUhjumU
2wMLXyd7jhqU8oW06Tj05Oc5AbKt+M9ZGcfFTDqcqE9uvS5dgAO5Aws/sUqcflXM
bipK2m00VAPPoEeJ2cLghjpxqFeR6YnZjiKel09lr13CBI4exWD2NJ+zLlGxq2I4
Yu2ypgirBZ5v4+F7wt4eDvYOQxxKc8yhyeGqh0GglSw3YP00+VwP8f9pLs6onXht
ERkFkRZUyYV10j77xmOZm77YqwzeMDpfyJglO9lv3+lMGS9EF6IZM7/DuQ4q1+8u
nF5BNmhYC1sRL4vWwN489gADpz6gOjR7RVYxe6hBXfe38HKkDO41FbBrPN1WxBMw
LSh2m3tH49NPua6KQRLYt2V6GY8ei6VObxn3TUeT+pOrnnG3Y7oGU1qVlC+4dq6O
hEdRr5WLKwUhCdnxuiOuG6wAlnKWrH2RIyYAsls7cMGDOdPBkzaRUezDpHNP82FN
0OymDM1v/BJZ5HdPRqZwYF8Jr4/rRtYegmVQU1XWw0aefryc3bI6wTAlJknWyjWD
T175M40ICwNKHoIYwKr2W14+VpzNJ0z1bzwJJs+WLc/WAZBWMmANi40/qXwGAm59
5yIHlDhgO69oVy7OMoDN1qxgrL2F3FTvEp508vk+seuq7pKDpMGUlY2EXf2KkE1p
akrQl9O4lwhiOh/0sxuU
=PiGA
-----END PGP SIGNATURE-----

--nextPart2383061.Y6vExabAUO--
