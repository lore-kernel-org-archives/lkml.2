Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1GZPYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:24:21 -0400
Received: from home.keithp.com ([63.227.221.253]:54931 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab1GZPYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:24:15 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] drm/i915: Delay 250ms before running the hotplug code
In-Reply-To: <CAKMK7uGHiXRU_3AqfOdLSmQsgMgf=Ah1_zf3k4T5E-7HC-f=Ng@mail.gmail.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com> <1311662194-4050-5-git-send-email-keithp@keithp.com> <CAKMK7uGHiXRU_3AqfOdLSmQsgMgf=Ah1_zf3k4T5E-7HC-f=Ng@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 26 Jul 2011 08:24:12 -0700
Message-ID: <yunpqkx2hgj.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jul 2011 09:44:32 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> queue_delayed_work? Plays nicer with other workqueue-items.

Yeah, I'll change this.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOLtwcQp8BWwlsTdMRApymAJ9cLXU9IprjJcRz1/cp57QnfrgyrgCgvD6G
agAo0Q+ecmRWgURl5nBGD58=
=oISt
-----END PGP SIGNATURE-----
--=-=-=--
