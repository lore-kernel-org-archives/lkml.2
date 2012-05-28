Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2E1GnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 02:43:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:14192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2E1GnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 02:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="148465504"
Message-ID: <1338187619.2480.9.camel@sauron.fi.intel.com>
Subject: Re: [RFC v7] UBI: Fastmap support (aka checkpointing)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Date: Mon, 28 May 2012 09:46:59 +0300
In-Reply-To: <20120528093625.050badc6@pixies.home.jungo.com>
References: <1337771191-95358-1-git-send-email-richard@nod.at>
	 <1338036094.2525.7.camel@koala>
	 <20120528093625.050badc6@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-m3vkeQASIyXhV9Ycnf2V"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m3vkeQASIyXhV9Ycnf2V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-28 at 09:36 +0300, Shmulik Ladkani wrote:
> Hi Artem,
> Fine with me, I'm flexible ;)
>=20
> What's your plan for merging to the master branch?

Once it the review is finished, and we test it, verify power-cut
robusteness and resilience (we can discuss how separately), we merge it
to the master branch (by squeezing the history I guess).

> BTW, I know you formerly disliked the idea, but I'm in favor of having a
> CONFIG for the fastmap feature; with the config disabled, UBI must
> behave exactly as it was. The config can be later removed.

This makes maintaining difficult - I'll need to have another
compile-test.

We should have an ubiattach option instead (and add this feature to the
attach ioctl - thankfully we have unused bytes there).

--=20
Best Regards,
Artem Bityutskiy

--=-m3vkeQASIyXhV9Ycnf2V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPwx9jAAoJECmIfjd9wqK0yUIQANBfkIxShVEAe4xuIvVsFKvA
zC/kiXxGGZNoXD4KNUfDcdUa3Ctk0OD61Qpb0XsekoSpkW4oQux79BOAi+HKqlef
dLYqGN/IbN/BZTjSyhyk/K7v2E44+LvhjFsf+MuC0eYUgRGd1r1vAmwg1eresPRZ
6EmBVf6Wpes+WjiYwK2Vw8I6XOebr9wmlsalqnHCGgp6IQSPsoFPK4Ciejth6jbk
hjybO3iaq5F9YS5q6+TlhJe1eg/1C5okwPbnxN9TpXud18GJmU6RnbSMhRfkHTl8
GghigWgkcJOAn4hbwH8as4JI7oWjtvFWjdofkidGMd36LUs1+MrMTQOAmZ7ixrKR
RK9PsjRHkmNRvXppN9J+TAwQl60CWtR1iQZESj1y5EuiOTsJoxTGCfV4bxOi3zWL
sUsTPBxdLvDVH6NDpP2ICaOXcmWx8ywMyDvPWTftI1I45iqKCvVeE9Ce9eXlXG9e
B26ly46A0ywtRonu7IHwXccWUNUbndSy4AbUIsJfZuNiopEWi0TzghFrbbR6xzb6
NlLMB40EZhZPE9+DdusFL9efxC6/yu++1XViWkhW5GnWSbsRK4JYm+oyoll+m6ci
S45sICCD4JrWd5ofgVdVpgpN/mXPCUXPI+3vfZFL2tX9UVFE81eR7Eo01YC74woc
3UMkAQVfYNgIhSpObwZt
=x0pq
-----END PGP SIGNATURE-----

--=-m3vkeQASIyXhV9Ycnf2V--

