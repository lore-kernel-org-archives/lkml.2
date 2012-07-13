Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab2GMFqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:46:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42744 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab2GMFqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:46:46 -0400
Message-ID: <1342158089.23418.12.camel@brekeke>
Subject: Re: [PATCHv3 0/4] hfsplus: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jul 2012 08:41:29 +0300
In-Reply-To: <20120712160951.74cbb3c1.akpm@linux-foundation.org>
References: <1342103191-17406-1-git-send-email-dedekind1@gmail.com>
	 <20120712160951.74cbb3c1.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-d+jjxYgdxbN21vUEhCY3"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d+jjxYgdxbN21vUEhCY3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-12 at 16:09 -0700, Andrew Morton wrote:
> I really do dislike dropping patches and replacing them.  For a whole
> bunch of reasons.  One of which is that a wholesale replacement
> requires a full re-review.  Another is that wholesale replacement makes
> it hard to see what was changed.

I will keep this in mind and in future will send you incremental changes
instead. Apologies Andrew.

> This latest patchset is identical to the code which is presently in -mm.

I am now away and cannot easily send you a diff between v2 and v3, but
it really does have changes - exactly as I described - checkpatch.pl
fixes (spaces replaced by tabs) and one line removed. Sorry for
confusion, I really should have sent an incremental patch.

--=20
Best Regards,
Artem Bityutskiy

--=-d+jjxYgdxbN21vUEhCY3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/7UJAAoJECmIfjd9wqK0N5oQAMgK2wK05QKNn6fmVTFVGReX
36zqciCohdQp1mdgvjvfLcufWyBY09w2OlppVbXMFgTrDfeMl+ulXjKZlKNXgl2N
XcN4sjd4RXOevOsZcKaGmcHjUf+sfUpQJa8iKgg6xQRDv68bR+ZwFt/7TnCteNUg
DDsCOxrr6eQFAU6ULbzVdPGbSj3VEwcVpT6kg4riOXLglT5QcfvW2yAdurHAYkuM
5ralJn9rWj8YWv1CplG7LG4t5WB9lpf6JiAIVN/cDzWiAd2r0JUo5nTykkzgJNbl
Ufo0oLxb5atqCK/H9Y6lh7SzhkD1vd1N8kb3+5YMT/ZsDymWyA2hDeJ2ewTEt/tJ
NRyNTYgI9XWQ0HDEeh34XRlmM8ZtNqaRhgSa3YaOYFudN3jtmVhsY4INAS9Xe3/i
9cx+sEhVB9nQ/RVlz3hqN2QP5lpGTUJEGSPoze8HFa5QZsBVFRVZGZdoXPgg3rKe
5EstqQkIsDOmJwkxSRhNnqHbjNLoUs1ZPo21CalRAz/Arh4SrNL66BO0oCFVpHeG
oP2FFSPVa8+iB6P1/JYYMQ7iUKy7T2gbdEtB+iKWYbRjKUp407rHbTnDFiH4TjyV
4qzeW7kVGA2Bd40YsC7EUjMtwsQFpKRFT9hLW5nyTLUi1LTRpXazjIp+H2S11LTr
w6ZTF+n2lGws3J2HRIqE
=lgo2
-----END PGP SIGNATURE-----

--=-d+jjxYgdxbN21vUEhCY3--

