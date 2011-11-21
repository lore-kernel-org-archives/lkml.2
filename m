Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1KUSKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:10:45 -0500
Received: from home.keithp.com ([63.227.221.253]:45320 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab1KUSKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:10:44 -0500
From: Keith Packard <keithp@keithp.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
In-Reply-To: <s5hd3cn3unp.wl%tiwai@suse.de>
References: <s5hlirgm1kg.wl%tiwai@suse.de> <yunsjlnl1f6.fsf@aiko.keithp.com> <s5hlirelndd.wl%tiwai@suse.de> <861ut5mdvn.fsf@sumi.keithp.com> <s5hr5144ecu.wl%tiwai@suse.de> <867h2wklln.fsf@sumi.keithp.com> <s5hd3cn3unp.wl%tiwai@suse.de>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 21 Nov 2011 10:10:38 -0800
Message-ID: <86zkfpgxcx.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Nov 2011 12:22:50 +0100, Takashi Iwai <tiwai@suse.de> wrote:

> So, writing bit-0 caused a problem, as it seems.

Thanks. I've noted that in the patch message.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsqUHjYtFsjWk68qAQgmGA//VAZYhC5pcDk73iU32uSQuKPnt36yg8T6
z671LTDETr1LC+lPRsW2xnhzPz1di5C+i+nQGdAujUCtSo9tIJLccJDtgYHuAkwO
cbs9ik4Xy1sLh7t4L+aub8YGcXZgTxbn5rxtr5bB+8RZ/xrOfA6Y6rKXQZhn/iKH
CIPGfIFffomNE+Ybt7g75k2wU00qiC9PJNVFPqgG2ovRtm9BkcHWA913VCLGMkFl
f0c3TSg/euFsK+296YJxPc1xIgel9vUNr1/ejn5fIV6i7QEliO17Fe4s8xfHrPS4
PxJikq5LhUkKF6BtrDD6+M/t4KJWdsdm/VbKf4CwVLEuXpLovty3S6VENlUVo7sp
8K2ylK4dLSYMS6qi5+2SCNjxHevo3glLqBaUxw76KRI+FCyqO9JzMEHbXmk4v4Ot
LRKeG6qvX3bmzrc2sQIjmdiUD0kSZiNpvoZddieFevmxpMIsaJ4sEzXBdhWLlJn+
8J2fgsLk+j0/zQ8bU6fznGlSrivO1VdyZddGsal2Z+Wj9SSHogCmjtzZPlkXn0x7
duavKbopZL6YnMfcpM7aDGPR7yi+8+m/pWFMfj78rqMYZzsAqJ6RHRqsQTZHuH9C
UCzpVveyg6XAmaZJO4rdtft9PCxhcEz/U1zdy2eCCM/CSeaK0LAYaTso+/PomqGI
1/gbgsvO+I8=
=HTsT
-----END PGP SIGNATURE-----
--=-=-=--
