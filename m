Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0IQMvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:51:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44490 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0IQMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=iWXqjJkKdF8U4e5d2LCzEbBafUlXiQtynamcyVuGzUA0ef4gKJnyOvIaGd6D/TncJv
         apZgtIpAkzLpTATeUkc7Rd2ucqohtMi3byOF88AgGOXGtlUVwWzP8QU4qizdn0a971py
         kjEXhD81JnWH5bI03nGbYEJjuuvwTRhxC1WUk=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Intel-gfx] Interrupt latency on some 945GM platforms
Date: Fri, 17 Sep 2010 15:50:43 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-git2-anarsoul; KDE/4.5.1; i686; ; )
Cc: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
        intel-gfx@lists.freedesktop.org, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <201009132336.17310.anarsoul@gmail.com> <201009171002.09187.simon.farnsworth@onelan.co.uk> <4b4d1e0a-b1ad-40f1-a829-6d4726d2b2d3@email.android.com>
In-Reply-To: <4b4d1e0a-b1ad-40f1-a829-6d4726d2b2d3@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1400016.MXPSkUraqt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009171550.48480.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1400016.MXPSkUraqt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
17 of September 2010 19:30:26 =D0=B0=D0=B2=D1=82=D0=BE=D1=80 Jesse Barnes =
=D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> Yeah if that works we could definitely add some qos calls to the driver.=
=20
> When vblanks are alive we'd need a latency less tha the refresh rate, and
> when commands are oustanding we'd probably want it even lower.
>=20
> Vasily, can you try the qos workaround on your machine and see if it works
> too?
>=20
> Thanks,

Just give me a patch :)

Regards
Vasily

--nextPart1400016.MXPSkUraqt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkyTZCgACgkQRM6pQpltKE6TtwCdG28Q5npQYMn6N5iNCL/nfRZm
vQMAoLLabLdMMqUd0eIV5cGq06P0kFQ5
=1gfq
-----END PGP SIGNATURE-----

--nextPart1400016.MXPSkUraqt--
