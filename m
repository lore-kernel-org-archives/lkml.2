Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1HEMsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:48:42 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:60428
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756530Ab1HEMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:48:41 -0400
X-Greylist: delayed 3518 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 08:48:40 EDT
Message-ID: <4E3BD8C8.6000407@akkadia.org>
Date: Fri, 05 Aug 2011 07:49:28 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Subject: Re: [PATCH] Add cloexec information to fdinfo
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com> <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com> <4E0ADF27.5070805@akkadia.org> <BANLkTi=dQRi82gkDwtR3Kh2R7f0uGu7HpQ@mail.gmail.com> <BANLkTi=pUZnhBa9W0eobQ_RWQGtMZ3u6Eg@mail.gmail.com> <4E0BE6A9.3040708@akkadia.org> <4E0C7C95.4070803@akkadia.org> <BANLkTim=whb61nbCTH-jH6cYdLrja8VCSQ@mail.gmail.com>
In-Reply-To: <BANLkTim=whb61nbCTH-jH6cYdLrja8VCSQ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6CB8D9599C40473A17706DF1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6CB8D9599C40473A17706DF1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/30/2011 12:07 PM, Linus Torvalds wrote:
>   "I'm not going to commit it, but if others think this is a reasonable=

>    thing to do and remind me during the next merge window, we can
>    do it then."

Can you please accept this message as a reminder to include your change?

Thanks.


--------------enig6CB8D9599C40473A17706DF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk472MgACgkQ2ijCOnn/RHSaVgCfVPsG4BjgaHtQXWaaYSNxHJcc
w54An2OA9rZdxUmVbaU73kLbSre1yVGS
=txZp
-----END PGP SIGNATURE-----

--------------enig6CB8D9599C40473A17706DF1--
