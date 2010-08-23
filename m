Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0HWFnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 01:43:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:45450 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0HWFnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 01:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,255,1280732400"; 
   d="asc'?scan'208";a="650217564"
Date: Mon, 23 Aug 2010 13:43:03 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agp/intel: Fix dma mask for Sandybridge
Message-ID: <20100823054303.GC29442@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <s5hlj81cn4n.wl%tiwai@suse.de>
 <20100823013507.GA29442@zhen-devel.sh.intel.com>
 <s5h62z1ew1y.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Content-Disposition: inline
In-Reply-To: <s5h62z1ew1y.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.08.23 07:29:29 +0200, Takashi Iwai wrote:
> > Sandybridge can do 40-bit dma mask. This has been fixed upstream now.
>=20
> Could you point where is the upstream GIT tree and the corresponding
> commit id?
>=20

Linus's tree:

commit 877fdacf8291d7627f339885b5ae52c2f6061734
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Thu Aug 19 09:46:13 2010 +0800

agp/intel: set 40-bit dma mask on Sandybridge
       =20
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxyCmcACgkQsQQaM014GCeX4QCfUpRHhxSWNkYfI6F6Cs2jGePL
e8YAniCoefollI5mu/+PW1laEeOaBDoK
=NpWp
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
