Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0HWBfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:35:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:39358 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0HWBfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,254,1280732400"; 
   d="asc'?scan'208";a="599135351"
Date: Mon, 23 Aug 2010 09:35:07 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agp/intel: Fix dma mask for Sandybridge
Message-ID: <20100823013507.GA29442@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <s5hlj81cn4n.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <s5hlj81cn4n.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.08.20 17:36:08 +0200, Takashi Iwai wrote:
> Sandybridge requires 36bit dma mask, but the current code checks only
> against i965, thus it gives Oops with i915 probing on 32bit machine:
>=20
>    nommu_map_sg: overflow 14a000000+4096 of device mask ffffffff
>    [drm:drm_agp_bind_pages] *ERROR* Failed to bind AGP memory: -12
>    BUG: unable to handle kernel paging request at fffffff8
>    IP: [<f7fac57f>] i915_gem_evict_something+0xef/0x230 [i915]
>    ...

Sandybridge can do 40-bit dma mask. This has been fixed upstream now.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxx0EsACgkQsQQaM014GCe2KQCdE395saT+4bGgcC8ZrX2CC6/n
zq4AoIzjyh3NMYGQfs3cIXY58jd2bZ7V
=Wa9B
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
