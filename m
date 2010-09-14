Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0INMaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:30:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63073 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0INMax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=JHEqu4KRR6j/5wNXFAaO+uWSPKZxDaYppdG18QbkNuKrvq0RZ8vs/jsuKAFK24MUt3
         lV/ZML0ahfWAqVePznunEFObXp5DHashzgdaENHep1Smad0NSgDD+kNNm5y8wU+dO5dj
         J6Hb8N6Fl/9p8og9DORVUnhfuwPCLrvQfOkMg=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Interrupt latency on some 945GM platforms
Date: Tue, 14 Sep 2010 15:29:48 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.35-gentoo-r5-anarsoul; KDE/4.5.1; i686; ; )
Cc: Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <201009141109.41596.anarsoul@gmail.com> <alpine.LFD.2.00.1009141149380.2416@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009141149380.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1503914.Ki8j7LdYgD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009141529.53179.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1503914.Ki8j7LdYgD
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
14 of September 2010 12:52:57 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Thomas Gleixne=
r =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> Can you try with NOHZ enabled and the following on the kernel command lin=
e:
>=20
>     processor.max_cstate=3D1

It works in this case (gears in glxgears move smoothly)
=20
> If that works, then try
>=20
>     processor.max_cstate=3D2
>=20

Nope, it doesn't work with max_cstate=3D2

Regards
Vasily

--nextPart1503914.Ki8j7LdYgD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkyPasEACgkQRM6pQpltKE5KpQCfV5zWiCCc63gvN9xZ/wqFFzqL
6kkAmQGQ36Jd28xnGWK/TSQ5RZXdDl4O
=D7Bn
-----END PGP SIGNATURE-----

--nextPart1503914.Ki8j7LdYgD--
