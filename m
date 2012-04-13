Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab2DMInF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:43:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:36939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab2DMIm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="128997261"
Message-ID: <1334306757.2544.77.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v1 0/3] do not use s_dirt in FAT FS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 13 Apr 2012 11:45:57 +0300
In-Reply-To: <20120413002656.b67e58ad.akpm@linux-foundation.org>
References: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
	 <20120412171257.a0fc35b4.akpm@linux-foundation.org>
	 <1334299108.2544.68.camel@sauron.fi.intel.com>
	 <20120413002656.b67e58ad.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qoTJPIuOACOPfHstqT66"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qoTJPIuOACOPfHstqT66
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-04-13 at 00:26 -0700, Andrew Morton wrote:
> On Fri, 13 Apr 2012 09:38:28 +0300 Artem Bityutskiy <dedekind1@gmail.com>=
 wrote:
>=20
> > > That implies that we retain ->write_super, probably in a modified for=
m.
> > > Modified to permit the VFS to determine whether the superblock needs
> > > treatment, if ->s_dirt doesn't suffice.
> >=20
> > I tried this approach and it was vetoed by Al Viro. Although it is
> > simpler to me to resurrect my old patches, I agree with Al that killing
> > '->write_super()' is a better approach.
>=20
> Well, it can be done without a super_operation vector - pass the
> library code a superblock* and a function address.  But the difference
> is pointless fluff.

May be, let see how many FSes will actually can share things. Per-FS
implementation is better because you do not have to worry about
refcounting and the FS gone by the time a timer expires. Also, when you
know the FS specifics, you can make a decision about whether the timer
can be made deferrable.

Sorry, I did not understand what you meant by "the difference is
pointless fluff" - difference between what and what?

> > Also, if you look at this from the angle that only few old FSes will
> > have this, it becomes not that bad. I assume I will change this
> > patch-set and won't use delayed works here.
>=20
> I don't think I understand that.  You intend to alter this patchset?

Yeah, I think I'll be able to implement one of the two ideas I described
in the previous e-mail, test, and send version two of this patch-set.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-qoTJPIuOACOPfHstqT66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPh+fFAAoJECmIfjd9wqK0nJoQAKIwxTrOOsOhiKcBmU+SeNLT
uvv2RF86TLA3uaX+XrnHmIsfjCJxVifvv6PVLDxLuavC7WkGFxpx3o7ni1gVwRZX
XhvEhGJPB2XgSv2kPQJ9OvlS0rFOOp6lwAi/dTJHwtShpV6wC0ifa7VJEoZGmSzp
u1rAzq5tg78Q0l0tzObbQjcCJwUcb/09Fk57Fgm1qYa53V9A7Aer8yNaXPSrJBhw
b8E8mGUaT4eV7MjjjUq/QMkOBTFIDbB7WDotxvcPbk/DPld/7DN5jOn6t0yovNeW
5qYWD+z8vuD493n8MqfbWxP/2V9m0FTnUCqJxM1A1PxtkakBOLJunKd/kar8cRat
3FxH/iA53MQq/rFtYd8qDAjIMzt/V8Tfvqr8Dd/MFWgTE7vgddv8Z/VHNSyL4jJl
FUpjkZk5M5ghTkxSw6vJx2aHq91jf/V6F6WRJtlw1dF0IKScU7TIN/N6HKGSV1Dq
7AS+NHqq9QoEDeykVroyCkX3RgaP2cvXv2yZIxtYpJhmzLnDtDQk2ZO19F5ZYOZk
gqEQH2UhQO4qnXpFcK907tKhFNHd1MjlOUI+bCsaHbefLh0knpUhsi54dnGJEHhV
0FmrW0F4mkl1z3t0r50l5BhpEIky67SJBfvGpSc7yVtVrMSx7FXcLb57PEgGoaWq
xA+RTo9u8Dsp2HFU+uXc
=3XaI
-----END PGP SIGNATURE-----

--=-qoTJPIuOACOPfHstqT66--

