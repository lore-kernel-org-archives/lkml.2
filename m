Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0IPScJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:32:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61128 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0IPScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=At8uTW+at4Sdbf/rjaa5pXU9ZS5Ia/64UwFn/kymYEDPEqq40lyDI361ivsVQUMe/2
         o522hIZb78YK2DcMzQzzV08oSpTxdh6DVdbMkYoEFX8mePeMvW4iIV7lSkWTa5z9thuz
         cX/b9BUecc1eH+zo5lQ4rzJTVhVowdsixgM4U=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Thu, 16 Sep 2010 21:30:58 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-git2-anarsoul; KDE/4.5.1; i686; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <201009161803.10531.anarsoul@gmail.com> <alpine.LFD.2.00.1009162004500.2416@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009162004500.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1731822.tHHF88TaAc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009162131.03365.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1731822.tHHF88TaAc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
16 of September 2010 21:07:39 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Thomas Gleixne=
r =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:

> > Btw, Jesse, any comments/solutions/workarounds except one with
> > processor.max_cstate=3D1 in kernel commandline? Should I file a bug on =
fdo
> > bugzilla?
>=20
> we fixed a HPET related bug a few days ago, which might be the cause
> for your problem as well.

Nope, it doesn't help :(

Regards
Vasily

--nextPart1731822.tHHF88TaAc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkySYmcACgkQRM6pQpltKE4xqQCfZbgVfzLsn4kC1DH7RuLwqn5d
/J0AoI6lJ6F1nJtQ9SqMjCYwixwyXQGN
=gzdZ
-----END PGP SIGNATURE-----

--nextPart1731822.tHHF88TaAc--
