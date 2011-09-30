Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1I3Ro1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:44:27 -0400
Received: from home.keithp.com ([63.227.221.253]:37807 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab1I3Ro0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:44:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 02/21] drm/i915: Shut down PCH interrupts during irq_uninstall
In-Reply-To: <20110930162048.GB2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-3-git-send-email-keithp@keithp.com> <20110930162048.GB2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 10:44:22 -0700
Message-ID: <yunaa9m7wnd.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 18:20:48 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Shouldn't we mask/ack south DE irqs before before we mask DE irqs to avoid
> races, i.e.  move this new code up?

I don't know. What about the GT interrupts? I just stuck stuff at the
bottom, figuring it would do the least harm...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhf/2Qp8BWwlsTdMRApNVAKCMHaUz6+YDK6Ov5W1wAY3ziKHxyACgqqPD
fSBi3AF+Nu5vcOev97PrM4A=
=Z+lo
-----END PGP SIGNATURE-----
--=-=-=--
