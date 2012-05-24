Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2EXJSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:18:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:23161 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab2EXJR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:17:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="170780165"
Message-ID: <1337851299.15137.96.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Date: Thu, 24 May 2012 12:21:39 +0300
In-Reply-To: <4FBDF0CB.4040501@nod.at>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
	  <1337608916-49771-2-git-send-email-richard@nod.at>
	  <20120522180119.2c2a10a8@pixies.home.jungo.com> <4FBBC4EE.4040802@nod.at>
	  <20120522211809.53bd6444@halley>
	  <b3d5919d0b35bb559b7dc115bc9e2720@radon2.swed.at>
	 <1337847592.15137.83.camel@sauron.fi.intel.com> <4FBDF0CB.4040501@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qCgeaxNMRiuznhLW8LmQ"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qCgeaxNMRiuznhLW8LmQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-05-24 at 10:26 +0200, Richard Weinberger wrote:
> On 24.05.2012 10:19, Artem Bityutskiy wrote:
> >> After thinking a bit more about this case I think the best we can to
> >> is
> >> switching to read-only mode if ubi_update_fastmap()
> >> fails.
> >>
> > Unless it fails because of -EIO, which means the PEB may become bad and
> > you need to pick a different one and schedule the faulty one for
> > torturing and marking as bad.
>=20
> Wouldn't make more sense if ubi_update_fastmap() handles the -EIO case=
=20
> internally?

Probably, I just meant that at the end the faulty PEB should end up
being scheduled for erasure and torturing like all other places do it.
We should preferably have one code path which marks PEBs as bad. It is
much easier than to make changes there.

--=20
Best Regards,
Artem Bityutskiy

--=-qCgeaxNMRiuznhLW8LmQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPvf2jAAoJECmIfjd9wqK0hf0QAMSEx8rD+ao2IattZHAvlkv5
nmIHSh0/L8SDObd2osriJrWgQXgBxKEfdAvxiq5wlVvYSqWtv6uLvmJyW6d3r2Rz
78DWhHzhVHbmjz3Wido+O707dHMm+eY+n7NjVPNtd2ry7ErzZh1fGjY8Meqo5iYK
JB+L/8TijxlMikWb6Qno3eBZYxj3M+ms7ktzYpQdrwwlJrGsbgtU9Zia8NCYYaSy
ACG2vEXoiO20J55hS+kIYQCfTNCJ/4TvzclYyly4VXpvK8e5X9qMit8rI5Fz7g6K
A7uyigWRb3nHw1kRLxdD7dCRfD9Fm2lkIz+SpgRcti0gIgRiHHEydmZencijSx5B
nw5AKksqY3++ha0uChkSYhH/hnZ+EoGbisSxW5a6rPaVh+moxEB8c9lK4eMp2A54
928T/o6BjgUqKHnx2qWKC9Vw8rvsQHEkj7R415V7sMF860fPFPN0wF60v9ZgtMUx
RA9XLjh5LDGF81sktZt20qvyNgVhoh6ZOakpZBJJ85+OrwxA4cyxDAvbj8on2uU/
ymRl6zyHtzppfjffSBa5x+b+JaiVTmaJpLSTCb6MElu+abK1T1YcG/20htEO5a6E
P4WkMJQBbV6pZa4rZ1bQfUZcy0kxfPDzIxAn+8H1N8+wtgVyjICP4GPhzvLpC/L8
1dOU1aVECDoPAvjaBc0S
=/44u
-----END PGP SIGNATURE-----

--=-qCgeaxNMRiuznhLW8LmQ--

