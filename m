Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1HRJVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:21:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:5265 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1HRJV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:21:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="39596440"
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 18 Aug 2011 02:21:25 -0700
In-Reply-To: <1313657762.32547.80.camel@Joe-Laptop>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
	 <1313653632.2128.88.camel@jtkirshe-mobl>
	 <1313654341.32547.62.camel@Joe-Laptop>
	 <1313654829.2128.94.camel@jtkirshe-mobl>
	 <1313655365.32547.68.camel@Joe-Laptop>
	 <1313655961.2128.107.camel@jtkirshe-mobl>
	 <1313656307.32547.73.camel@Joe-Laptop>
	 <1313657022.2128.116.camel@jtkirshe-mobl>
	 <1313657762.32547.80.camel@Joe-Laptop>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-h0gxOEqQjC+0fz2qJq1m"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313659287.2128.133.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h0gxOEqQjC+0fz2qJq1m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-18 at 01:56 -0700, Joe Perches wrote:
> On Thu, 2011-08-18 at 01:43 -0700, Jeff Kirsher wrote:
> > I understand what your saying, and I think that your suggestion about
> > possibly implementing a "--input=3Dgit" option to checkpatch.pl might b=
e a
> > happy middle ground to resolve the numerous false warnings this check
> > produces.
>=20
> As far as I can tell, --ignore=3D suffices.
>=20
> If you really want to use checkpatch for checking
> already committed patches, maybe you should not
> use git log but use git format-patch instead.
>=20
> $ git format-patch -1 --stdout | ./scripts/checkpatch.pl -
>=20
> That works without any problems.

Thank you Joe, I will take a look at how we validate patches with
checkpatch.pl and hopefully we can reduce the time I take reviewing
checkpatch.pl warnings.


--=-h0gxOEqQjC+0fz2qJq1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOTNmVAAoJECTsCADr/EWUb1wIALEZjdFzJqeffk1lWhka8bpC
4+MZGCok+KTTqoJfgm53dOOlL1v1uHpsM+ar+Sgrz4s58TBuQRJZ+xsSknuka9MG
jBwuHTPhoiwZ/HtglvcK904WuxguONPFWvtxxTPtQX1Yolxxod4ydpJAC1p1jFR8
Hbujr7/hI0A9WhMZCLHlmeeWV1gs48/Y1ehWBsWC/N0/5mx8bE63H9g90WM8oi6s
frKvzPCwzZHmFVhpn5XZTgKt4wJtZ7wwq+PMS1JFEwn6rSrzr3oX6uvacrgzRoZi
kiA1yEb52z7KdJDYfQDw8Qni8t/Jvkpy4B/moqVl6Qtfc/+LLTeaEoB94x9/wzM=
=SBH9
-----END PGP SIGNATURE-----

--=-h0gxOEqQjC+0fz2qJq1m--

