Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab2AJIyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:54:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:50154 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab2AJIyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:54:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="96420470"
Message-ID: <1326185831.8847.17.camel@sauron.fi.intel.com>
Subject: Re: [GIT PULL] UBI/UBIFS changes for v3.3
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Date: Tue, 10 Jan 2012 10:57:11 +0200
In-Reply-To: <CAFLxGvy7MPfBp=prAqELwcWuHFjB0qnNrTRzmoGBN39==G76Dg@mail.gmail.com>
References: <1326118036.6755.101.camel@sauron.fi.intel.com>
	 <CAFLxGvy7MPfBp=prAqELwcWuHFjB0qnNrTRzmoGBN39==G76Dg@mail.gmail.com>
Organization: Intel OTC
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PBPOZoylA/r8OYsGtVTG"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PBPOZoylA/r8OYsGtVTG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-09 at 16:00 +0100, richard -rw- weinberger wrote:
> > Thomas Meyer (1):
> >      UBIFS: Use kmemdup rather than duplicating its implementation
> >
>=20
> Where is "ubi: Make vid_hdr non-static"?
> http://marc.info/?l=3Dlinux-kernel&m=3D132456978023418

Linus,

just to elaborate: this pull request is still valid. I'll take care
of the other patch separately.

--=20
Best Regards,
Artem Bityutskiy

--=-PBPOZoylA/r8OYsGtVTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPC/1nAAoJECmIfjd9wqK02VEP/38KgR/D0vQNl4GnP7gUD1+g
VLCVrbN1+3cjcg3I4dib92GI8T+0K5n/4rTj9C02cf103LaKEzt//fqSsnUK62Bo
8l25msunQD+CSy0J1dyFNPtUu8fwjkLasy1Tn2pm7ArD67x5GOQJxJHXjL4hMR/b
Qa446P3dgFtZDXqrHfT6vcA/mwnqaafpJ8BXWeJyDWIcTiHAcEygqD1O9E1zKUhh
ykHYvk1mEK7Dk9ttYBriqOzwDMIaLZnxnMPX9JtHKK1Ussspb/FrzIreyG8elYu6
1jym8IEI7jjUD76cG6ZlcR/p9zBcokVatnNEXWbQ8gFbAOmO4VDdtTl9pgCRNaRL
lRwa9+dC3FeS1PyC5kVbbhx9OjRFH++VXsUElaC6PhTL5qZ7u9GV0xnSQxuTV63S
Ulnq1t0JwGa91unr4EMfe4/gMqGka8IcJ/XxYRGQde+nzsVxk8IUZe/MTAZq2b7x
wbfvUBEtqhgUdWiiD0vZn1pD0WFseCNkm3Kby/Dzm3djA4xYvy8SjVO4K5wSxelg
0GK/AL8qHPueTGJ6lhVnjNcsluI89QSgcbaSzhraN14LP5BioDYjLu/eANz71E55
Acrajj2PdycDKNrOHYa99EcVVFi1ZJpkjMFPNqEbOUcqFqsUKgiMEycarWYLhTkN
eqOGeK18yklykTU/Gc0e
=2YU0
-----END PGP SIGNATURE-----

--=-PBPOZoylA/r8OYsGtVTG--

