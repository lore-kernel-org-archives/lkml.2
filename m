Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0IJQSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:18:09 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44937 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab0IJQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:18:07 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Fri, 10 Sep 2010 18:18:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-tp42-toi-3.2-rc1-vmembase-0-05032-g60140c1-dirty; KDE/4.5.1; i686; ; )
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Paolo Ornati <ornati@gmail.com>
References: <201008312153.45792.Martin@lichtvoll.de> <201009101549.03845.Martin@lichtvoll.de> <412F0940-B810-4F19-8064-CD3E11DEE8B4@mit.edu> (sfid-20100910_180124_061897_26E96354)
In-Reply-To: <412F0940-B810-4F19-8064-CD3E11DEE8B4@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9324159.vo7UNa8elZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009101818.03436.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9324159.vo7UNa8elZ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Freitag 10 September 2010 schrieb Theodore Tso:
> On Sep 10, 2010, at 9:49 AM, Martin Steigerwald wrote:
> > Maybe next time: "Fails to boot with partially shown backtrace, with
> > some ext4 / readahead function calls inside it"? Or even more
> > general some I/O / filesystem related functions?
> Learn how to use a serial console so you can get a full backtrace, thus
> saving yourself and folks interesting in helping you valuable time?=20
> :-)

I know how to use a serial console. Actually I am no freaking idiot at all=
=20
and I do not like being treated as such.

I just did a bisect, and these kernels were unbootable. I didn't think it=20
would have been worth the effort to put that much time in it to grab my=20
other notebook, remember how to set up the serial stuff and all - when all=
=20
I wanted to do was to complete the bisect.

I already told that I missed reporting that I do not need any information=20
relating that issue anymore cause I was able to skip the area with that=20
unbootable kernels at all. I am sorry for that, cause then you would have=20
known in advance that there is no need to do any further analysis.

Its getting a bit ridicolous now. I am done with it, since its no issue at=
=20
all anymore. My current 2.6.36-rc3 definately boots, so does 2.6.34 and=20
2.6.35 and thus the issue is gone and all is well. So can we be done with=20
that now?

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart9324159.vo7UNa8elZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyKWjsACgkQmRvqrKWZhMdJRwCfSZ9BNm7BGS7IaHQZWzzcimFs
wbEAoLMT9m81nvxGC/qKpX6gVtNN7Pv5
=pkVw
-----END PGP SIGNATURE-----

--nextPart9324159.vo7UNa8elZ--
