Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1KURRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:17:00 -0500
Received: from home.keithp.com ([63.227.221.253]:39261 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab1KURQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:16:59 -0500
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>, Rakib Mullick <rakib.mullick@gmail.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
In-Reply-To: <20111121162306.GB3807@phenom.ffwll.local>
References: <1321382968.8791.4.camel@localhost.localdomain> <20111121162306.GB3807@phenom.ffwll.local>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 21 Nov 2011 09:16:53 -0800
Message-ID: <868vn9ieey.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2011 17:23:06 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:

> Indeed, nice catch (albeit totally unlikely to be hit, because the error
> only happens when the gpu ceases to progress in the ring, so imo not
> stable material). Keith, please pick this up for fixes, thanks.

It's already there and queued for airlied :-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsqHhTYtFsjWk68qAQgJRA/9HsK3cXrJ+IF6h5vJoxPd6QExaqU0H0Cz
Itv6Sq49+UYvL+PPMYttntrnQSTLutDEKYXxk7KQ8xzrBmtSvce9qWWiPMEwj3Qm
n2tcPbsM4FbNK3KpauFnzAdSgiVtO1WJTZ030Lsd5zVzumzKo2Nq62fKZl9oXnGP
eymF87aknQ/2fO6dSHMUsf02lNPbLsOy3JOc9j9yj9VCqq8v6rqDM4kzy45Di6bV
z98Mqd1z2C6fPBWBppr6w55B1htVkGajS6U3rwt+/ael+uhK2nUmXXCQP8A+khjH
qXTnFEpErem81Khy+saYQrvqgWAuZVTTskFkCJPYHtwZSCFzP5/gx9aWvtDRC8NN
LPHO0vZSjJbu4kLKYMQ3025lM6EVfoj7CZ8JCfoteXj2sf6o9PgQuDqFYYcwPrJW
cnbqpM8nFRjSEo859vbRBMk/k4MEXjcBUI4LDByIqcgAbu0NMzgirhegaT5epJjv
9N2DmrxcbWY1aMGbFVrPlY7RaFrGASSXddpGGqV2wKL8HbUylB4ZgFzBTBnaWtfV
84gL3yi+j73226jGFY9lv5Xr3fcbVGghj/Txcs81rEqxP7U96D7fMjDaut4OzbPX
ZTcBLVtqk14dfAkWM8rqvKh0e9p1Jb/5L7GGV8Pajc5vkDl8EBMcRKnFhGE443ev
Q53libBAZzY=
=J9ek
-----END PGP SIGNATURE-----
--=-=-=--
