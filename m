Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0IGCAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 22:00:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:42532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab0IGCAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 22:00:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,327,1280732400"; 
   d="asc'?scan'208";a="552150581"
Date: Tue, 7 Sep 2010 10:00:28 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [git pull] i915
Message-ID: <20100907020028.GG27129@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <89kc63$i063ms@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <89kc63$i063ms@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.09.06 09:30:23 +0100, Chris Wilson wrote:
>=20
> in order to reduce the burden upon Eric and to try and feed patches
> upstream in a more timely manner I volunteered to take over maintaining
> the upstream i915 branches.
>=20

Chris, could you help to check my sandybridge fixes? One is address mask
fix found by Takashi, which should have been applied but I can't find it
anywhere upstream. And others are PTE cache control fixes.=20

Please check 'for-ickle' branch at http://cgit.freedesktop.org/~zhen/drm-in=
tel/

thanks.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyFnLwACgkQsQQaM014GCdhvQCffEMJElY7OMTrtUl3glq6uQMV
vbwAn3HDoTHEUJ/53/XTz9qr40KbNjVn
=iSL/
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
