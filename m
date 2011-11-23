Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1KWT0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:26:48 -0500
Received: from home.keithp.com ([63.227.221.253]:49370 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab1KWT0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:26:47 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang\, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] drm/i915: hot plug/unplug notification to HDMI audio driver
In-Reply-To: <20111123082958.GA4209@localhost>
References: <20111121063749.GA23450@localhost> <86hb1xife8.fsf@sumi.keithp.com> <20111122074055.GA21560@localhost> <86sjlgf20l.fsf@sumi.keithp.com> <20111123082958.GA4209@localhost>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 23 Nov 2011 11:26:49 -0800
Message-ID: <86fwheej2e.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 16:29:58 +0800, Wu Fengguang <fengguang.wu@intel.com> w=
rote:

> What I need is a hot plug hook that knows whether the monitor is
> plugged or removed, which is only possible if the hook is called
> after ->detect().

That would be mode_set to tell you that the monitor is in use, and the
disable function to tell you when the monitor is no longer in use.

You do not want to do anything to the hardware in the hot_plug paths;
those are strictly informative; telling user space which connectors are
present.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTs1I+TYtFsjWk68qAQg9Ig//QaQYbkDtnBJxDDGunRl/mX8qrTXFc6KW
racyqvW89/+Il5xDN379NA+73A04eHfAe9/JZNEO5WHJ5pyc1Oqmyt7nkBn7N2ps
71fpCw7uHvQkZ427gxr3RqZIJz2YsVRoHSO2vNLRsFjqlymooVZJ9Gbz5Pe0/n39
wt2hQmyFpL5IDNpk/PHjRFCPVHJL4uM+iSbZuTGBYAmcYb7w173iWej3Xt0TIKM+
jEIufd25uxt0Z89aMNoAFQEuXUGbVXEfSbquFCxX/1fHq1/kDgw65ic3yceFegGB
B5juEjSJupciLlIdo4spJX3gVGCI/ER1mlWUWAq+Zfw8XaJgMikBdehbykFFQpve
U79xIdBqaK7ZvzzGhkQG5FA/XMMB4XMumCGDmlycSBE0NE5J9h6lRwmVKnvZXKSr
D2ujPK8OhicnDVvD5jAfoxScX7nijeX1YR+QDRNTgHgW7HKBpXv08ZuW8Qc4jOEg
vY9XV1oaqc7+GGRz42N5enkOfrpSWsBL/mT+0b0PchSnYVfyz9eI6qoSMurnK+IG
CVCS7nnFC73CVz8dSUt2c+o8rd7Kqae+OBGhumekcpcXrOLox+1HLGt3ZmreDyxp
9vHhpIgmq98b5GNu0+OkWN6Zx0xa4feATN7gTzzVcvDrRW+OSgeqdxp0cFlXh0uc
SI1M3ToHmUw=
=esq4
-----END PGP SIGNATURE-----
--=-=-=--
