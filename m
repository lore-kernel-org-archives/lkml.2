Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab2FUUxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:53:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59892 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760249Ab2FUUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:53:44 -0400
Message-ID: <1340312020.2536.18.camel@koala>
Subject: Re: [PATCH 4/4] hfsplus: get rid of write_super
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jun 2012 23:53:40 +0300
In-Reply-To: <1340310656.2536.12.camel@koala>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
	 <1339587471-2713-5-git-send-email-dedekind1@gmail.com>
	 <20120621124158.a7559ee3.akpm@linux-foundation.org>
	 <1340310656.2536.12.camel@koala>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-5aNclLthawikZbeWfZoc"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5aNclLthawikZbeWfZoc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-21 at 23:30 +0300, Artem Bityutskiy wrote:
> Well, I also thought about this. But I again did not want to invent
> anything complex because main file systems - ext4, btrfs, xfs - do not
> use 'write_super()' at all.

Sorry, ext4 does use it in the non-journal mode but I have patches which
kill it, although not looked at by Ted so far.

>  And then only these dying / rare
> file-systems like btrfs / hfs - I did not feel like over-engineering
> is
> needed.

Sorry, of course I meant reiserfs, not btrfs.

So what's left is hfs/hfsplus, affs, ufs, udf, reiserfs, jffs2. I could
optimize them if needed, but is this worth the effort?

--=20
Best Regards,
Artem Bityutskiy

--=-5aNclLthawikZbeWfZoc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP44nUAAoJECmIfjd9wqK0ZBMQAIqu5e+KVLkwRgSSAMxrCAXa
wUpsRC0dHlJf81ht4FGuOe6PjzHefJ14/Ur7QwkfEoeXV2+DFjm+/+cwjjIgEVb+
XcmRSzyHG15dabiEVwDWGXJqowBaTKGqG3tbl7jOo5o+NLLiuBLeF0tWQ3jk/Zt0
2hA/a7PrzskTvMWYHO1R3Bm64UMdpJDtKCraDsMgjTdkayGOSpjkzyjH+XmHhQco
1oInR6vpl5948SuozrNOhF0QQzpT7EqaOQtoKT4EC+Vh//0aAp4/0MtM74VsgmQO
s2I9Q4qGeqQNb5vCoVU9sVoGfY40f3tBrzCnJYQmiFAE7Yfynl6BiNPo0hkEGszl
I8H7ua6DtIWdueTJT6IQ7N+FNUQgJybrkNwJAAcUfLz8EJBaf8a9ar3uJ61bVm5/
cr2bLQAZOX0Q30GwoTrRmaxJ3jH4MHY09KePFixeQAButD6MUE0Q1hMkBzDDOlz6
TK3ABc8sh//KG4/tM+ndmlJtPrcRZG+KesoMI+6a+8CksFLjCEOIt4XPxIj9q8Yy
CGWOQ3YyKyQ298eyLwgssKwqcXCVo4lWufROwmLjVm5c/PAhGTQX4N7vlZcbiHjl
htpu1GjdgOPYiNDcXtuHofASiGvP96J38TGyJemTwG8858hmhPmRIYtt1gVx1Taj
7h3H0+DINYwliPFUabaY
=SGML
-----END PGP SIGNATURE-----

--=-5aNclLthawikZbeWfZoc--

