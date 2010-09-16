Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0IPPES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:04:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43040 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0IPPEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=iBS22LpGUadla7nW8s7fw2n3xDu8ArksorE7nISsScYVCEBDVjKcnjE3I6UZrRjXB/
         Nu0PVdw4TV/2gH4MM6yWEIQj/kCLYxM4PIwZwVwhcMe+T7QPKEgYLYpprfKjV1SE76Pg
         iVBssKrZkqFkceiOD4LY/Fy4eXUaRatnakMyY=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Thu, 16 Sep 2010 18:03:04 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-git2-anarsoul; KDE/4.5.1; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <201009141529.53179.anarsoul@gmail.com> <20100914224111.GA14467@sucs.org>
In-Reply-To: <20100914224111.GA14467@sucs.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1556634.LA4EyHkQqI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009161803.10531.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1556634.LA4EyHkQqI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
15 of September 2010 01:41:11 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Sitsofe Wheele=
r =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > >     processor.max_cstate=3D2
> >=20
> > Nope, it doesn't work with max_cstate=3D2
>=20
> Perhaps intel_idle is being used? Any mention of it in dmesg?

Sitsofe, maybe you misunderstood me, I mean with max_cstate=3D1 graphics is=
=20
smooth, with higher values (i.e. max_cstate=3D2) graphics is jerky.

Btw, Jesse, any comments/solutions/workarounds except one with=20
processor.max_cstate=3D1 in kernel commandline? Should I file a bug on fdo=
=20
bugzilla?

--nextPart1556634.LA4EyHkQqI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkySMa4ACgkQRM6pQpltKE46DACfeD/4oJLLWf5k1dXQjfgQVwOn
gtcAn0fLjhj8tgNqzjQ9YQVlVXbY2X3m
=b6ik
-----END PGP SIGNATURE-----

--nextPart1556634.LA4EyHkQqI--
