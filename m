Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab2GMFkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:40:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42150 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2GMFkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:40:14 -0400
Message-ID: <1342157684.23418.6.camel@brekeke>
Subject: Re: [PATCH 0/3] fs/ufs: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Dushistov <dushistov@mail.ru>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jul 2012 08:34:44 +0300
In-Reply-To: <20120712155808.807ec3f5.akpm@linux-foundation.org>
References: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
	 <20120712155808.807ec3f5.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-FshP9UR4HYH8RymMSktI"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FshP9UR4HYH8RymMSktI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-12 at 15:58 -0700, Andrew Morton wrote:
> Just fix them up as you go - the code is already a mixture of "right"
> and "wrong" (a consequence of a lot of it being "wrong") - we might as
> well tip it further in the "right" direction.=20

Yeah, but I'd say 80% of it has its own "wrong" coding style, so fixing
it is a separate patch-set. Simply because when I partially fix it,
there are almost always context lines which upset checkpatch.pl, so I
would need to fix it all. I can easily clean it up a bit separately,
just let me know if you want me to do this.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-FshP9UR4HYH8RymMSktI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/7N0AAoJECmIfjd9wqK0tKcP/27tjVqxRgaL2zEpYHqmKZHc
ariIH8J5BUqf9aKSNUsrLP8Ttxa1PAcBoWk59WWrWCQ2XHkxTEiGF5d676U0j+6+
EtjVIdSX6l+bXKQlAlU8b2lubUPp+J+isrcVgYqiv5B9P8aoRhFPhpCLe3K450Jv
duyp/eVTY7rjpmVxBkH2lNOO16kBxs7sSxC8Zv9br7vi8yKnEEcakac7IbsLBHmM
3gWSEXEhvKvekhUGKtrjbrL+0EuOyhfH/5Boog7tH9KgnntU1cwhl4+r/DS0ZOWF
ztErsKqWosW2dF72ClSigTpk9CSAUT8SelgD13l3VSbY0fFIYcpLHZHwdyxJ5yXu
xqgoHHmEPoC56fPPVS9Mu+AycDI7oLQrSSP5rKLUA/BEh2IGtB2NvRWn/rbFojdB
OWRM67wA/2kfWYuLHHfP35TGgRrauBdjIH9Ju1UC+irwi6AIO0nQt4OTRu6WyXIm
9iZftJVnKW6GR1aguUd/zHXeUf5rher8leo1B6jZmFpnuHrnxURS3+Qw2/teOvwV
0RH1g6XDcX+g4BSF5ViE3B7ZECur8EDNWSXBWbYqbqK3IRPaMI8sSvXZNmhBsla/
p5JafGpGi4dukPlux5QjzJNMeNlh765AEuxOHaLpWeFORGgl2qS1P7FuxkSG18CP
MZ8AuNqKmbJKZOsjc+cl
=rPPm
-----END PGP SIGNATURE-----

--=-FshP9UR4HYH8RymMSktI--

