Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1HLRne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:43:34 -0400
Received: from home.keithp.com ([63.227.221.253]:53657 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab1HLRne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:43:34 -0400
From: Keith Packard <keithp@keithp.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: Re: i915 suspend crash: BUG: unable to handle kernel NULL pointer deferrence
In-Reply-To: <4E4564D0.70104@gmail.com>
References: <4E44C537.8040101@gmail.com> <yunobzusona.fsf@aiko.keithp.com> <4E454D75.2090505@gmail.com> <yunliuysgf6.fsf@aiko.keithp.com> <4E4564D0.70104@gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 12 Aug 2011 10:43:30 -0700
Message-ID: <yund3gaseyl.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Aug 2011 10:37:20 -0700, "Justin P. Mattock" <justinmattock@gmai=
l.com> wrote:

>   I have: Enable modesetting on intel by default (DRM_I915_KMS) not set=20
>   in my .config. I will enable that and see if this fixes this issue, if=
=20
> not then I will test those patches out.

Could you test the patches without switching to KMS first? Otherwise,
the underlying bugs aren't going to get fixed for anyone else...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFORWZCQp8BWwlsTdMRAnDGAJ0UyM0gVOgoY7Ua4bHu/PEqRllGLQCg6uwS
Eyhh2qsrlMnAzX/K58+quio=
=LVx2
-----END PGP SIGNATURE-----
--=-=-=--
