Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1JMNye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:54:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33519 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1JMNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:54:33 -0400
Date: Fri, 14 Oct 2011 00:54:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: currently missing kernel devel trees
Message-Id: <20111014005423.7f86fe250f05f90b9a8de9d3@canb.auug.org.au>
In-Reply-To: <CAPM=9tyWaL=ySxs=Zgfdde8Um4JbsB2Nem8Rsfaq7voLBv+Pqg@mail.gmail.com>
References: <20111013174358.b20fedb97c7b53db2ba82ff6@canb.auug.org.au>
	<CAPM=9tyuHeKgrh6iyJVUKF3rdy8-izwSJuJRBwCOSsz4DDsccQ@mail.gmail.com>
	<20111014003341.36bd655d41bf31804d720174@canb.auug.org.au>
	<CAPM=9tyWaL=ySxs=Zgfdde8Um4JbsB2Nem8Rsfaq7voLBv+Pqg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_00_54_23_+1100_ZlwpI=aYhmj_Ee.m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_00_54_23_+1100_ZlwpI=aYhmj_Ee.m
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 13 Oct 2011 14:53:27 +0100 Dave Airlie <airlied@gmail.com> wrote:
>
> > OK, I will switch to that. =C2=A0 What should I do about the agp tree. =
It just
> > has three commits that are also in Linus' tree (as different commits).
>=20
> drop it, I've pretty much pushed agp via drm tree now.

OK, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Oct_2011_00_54_23_+1100_ZlwpI=aYhmj_Ee.m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlu2PAAoJEECxmPOUX5FE+8QP/j8eJWkW9xZccVldU62/QksR
wWNQ71ugdAH7VlyMq0MeJR7O3Y/8GZG7Cbm6rmikOD7Z28ZscSN25tiKr7fV1Vze
5GrUqw/+DjlvLVFrJl64ztXFajA2URFJHqmGpQEhC0fWxHeqLzZQTnGfDtRJap19
WARoKVSscNfLj3dLdqxCPlqYTa8UiRk54LuEOkP0vsm6NvKuw6vWI98Ur7nU41tw
c/4cI/uoBY9Ch9bkTmQZYPkDiZM5pYIgoERW2fJ8TRDC27aeBune++zTtJZ3Wfae
joFsz4A2FQQqpVRuEhZc14u5KVNDl3BajvD4hvq324BZimSSN5L4mQ42Nbu3znQ+
+6wh4FafyGVD+R2tVIvbSke42CAVMzN8eFXxq4+BzRMMtCgsJlQZVU7W5m+u2cWK
7uhG9ErvaiPDImq44hdxgwAh52qVdFZnPZdCFUwgS6HNXQopH4dQA42/7i2LWm8n
1b+BhdmbPpYda2/pXhOD+dvyaO9se5USMWacJTajWTClXT2d1tIEH7aZ6If6eQwQ
M86y+q4+JqaTlXRAmbGi21bm7vkisGemCOdf5nvcIL9roKZ8YGLfcZF4yK2FY/8+
wCNp9Sc3CUBHlqF+zmO4Pr8sE5tCYgs/IKyaZzVnEvtojMskjMgRg6cPHPjD/KwY
JOd3itZCZcQWZ/5fVqYA
=ch/2
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_00_54_23_+1100_ZlwpI=aYhmj_Ee.m--
