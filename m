Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab1I0Qyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:54:49 -0400
Received: from home.keithp.com ([63.227.221.253]:48709 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1I0Qys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:54:48 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: PCH reference clock cleanups
In-Reply-To: <e39f63$23ptfo@fmsmga002.fm.intel.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <e39f63$23ptfo@fmsmga002.fm.intel.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 27 Sep 2011 09:54:45 -0700
Message-ID: <yun62ke9b8q.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 10:01:33 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:

> Oddly in the diagram SSC4 is given as a 100MHz clock that can be used for
> any output other than DP_A. However, the configuration register marks that
> as being a test-only mode.

Ok, it's all irrelevant -- the only configurations using anything other
than a fixed 120MHz were eDP and LVDS. LVDS used a value from the BIOS, whi=
ch is
presumably always 120MHz. eDP ignored the refclk and used fixed PLL
values.

So, yes, we can always set the refclk to 120MHz; the cases which matter
were using that value already.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOgf/VQp8BWwlsTdMRAiGBAJwLAhJLmEMTSABlvzg3NTbpBHAxIwCeJUQR
gZ+AwK0tMqnbzB4I40b6QUg=
=XHyB
-----END PGP SIGNATURE-----
--=-=-=--
