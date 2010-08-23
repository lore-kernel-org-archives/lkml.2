Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0HWOCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:02:23 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:56594 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab0HWOCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:02:21 -0400
From: Eric Anholt <eric@anholt.net>
To: Zhenyu Wang <zhenyuw@linux.intel.com>, Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agp/intel: Fix dma mask for Sandybridge
In-Reply-To: <20100823064854.GE29442@zhen-devel.sh.intel.com>
References: <s5hlj81cn4n.wl%tiwai@suse.de> <20100823013507.GA29442@zhen-devel.sh.intel.com> <s5h62z1ew1y.wl%tiwai@suse.de> <20100823054303.GC29442@zhen-devel.sh.intel.com> <s5hzkwddfy5.wl%tiwai@suse.de> <20100823061922.GD29442@zhen-devel.sh.intel.com> <s5hiq31delt.wl%tiwai@suse.de> <20100823064854.GE29442@zhen-devel.sh.intel.com>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 23 Aug 2010 07:02:16 -0700
Message-ID: <87y6bxqvfb.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Aug 2010 14:48:54 +0800, Zhenyu Wang <zhenyuw@linux.intel.com> w=
rote:
> On 2010.08.23 08:31:42 +0200, Takashi Iwai wrote:
> > > bit 31			 bit 11			 bit 4			bit 0
> > >    |<-physical addr 31:12->|<-physical addr 39:32->|<-cache ctl 3:1->=
|valid|
> >=20
> > Then I really don't understand why it works.
> > You shift 28bit and mask with 0xff.  Obviously it overwrite bits 0:3
> > with original 28:31 bits.  Masking 0xff0 fixes the issue.
> >=20
>=20
> ah, sorry, my stupid. Thanks for catching this!
>=20
> Subject: [PATCH] agp/intel: fix physical address mask bits for sandybridge
>=20
> It should shift bit 39-32 into pte's bit 11-4.

Applied.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxyf2gACgkQHUdvYGzw6vdUCwCghkscXUjV2TVmkXga5LiJPiN1
Dr8Ani+Voxx5jpvOfzNsUUEVA9e2P/x8
=yiHB
-----END PGP SIGNATURE-----
--=-=-=--
