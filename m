Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab1KBRbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:31:52 -0400
Received: from home.keithp.com ([63.227.221.253]:39102 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1KBRbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:31:50 -0400
From: Keith Packard <keithp@keithp.com>
To: Adam Jackson <ajax@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
In-Reply-To: <4EB17A50.6050804@redhat.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop> <4EB17A50.6050804@redhat.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 10:31:46 -0700
Message-ID: <yun8vnywhvh.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 13:13:52 -0400, Adam Jackson <ajax@redhat.com> wrote:

> Given the choice of trusting DPCD or the VBT, I'd definitely prefer
> DPCD.

Except that the DPCD is coded into the monitor while the VBT is done by
the platform. And, it's the platform which may neglect to connect some
of the wires. In any case, if we want to look at these values, we should
be doing it before computing the M/N ratio so that we actually set the
hardware up correctly.

Any bets on how long until we find a machine that has right value in the
VBT and the wrong one in DPCD? Or a machine with wrong values in both place=
s?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrF+gjYtFsjWk68qAQjl+RAApFoiivRBPDva2PREQX0S6ZKtBILSDJUS
Dhc4fPuEQHFYhWwR+S9T0nsPtdIWLbbgyrQ+uxKzkK/IKCvat5FToT32uj9bkc+q
zeJZXhU1F8fQIu3RfQLkGj/DmvztS6t1K0ST5AU/no0N9UWRbACPp5dIRo+Ym7g+
qiavjFMOZ+IpnjpWq/JEOXSJIbLZ0+bxoq1gYyOZyjW5zHcnBaaMgJDawzsY/LTs
ma8i2FipudlT7BgtpApuLJGv/1JImlO+07H/Rz6pNiinAIA4PX1SziOZwHGpbgIr
aQHzndYYJFiYciEAvC3sOZlssy/BumAAZdjXT5InC4BvqBzBSHgNYao94uftcYSW
4sE+48qMIiU/9XSHXDBpQTOJRH5GaURMNayoAF8ptieOnFpA3hdKYvMxcXNiq0N7
ju34VCiFDnJVjyr5r/GniUM7QW+xasow+OH1apoEmh6QclLW8xRa0OHCfjk5tgID
cQr6Y6hi9dW+wmDsX40lbxm1E3z8S0iPCzX4X995Mnng8Ny6k6Xr6LNWp939UWRi
U0ll+kI4HoXd8CmQwsXPb/3ZuVxNNVCSerffflitgHSytMachxfRaTdZhMZDPZ1y
qwoPgGFO67LXPEolk3ey6c6BJztFiDbkSmeYYZi2uLTtZPDFHZZ8v9x1pAu3QQq6
pmb3NWjuIYk=
=ciXl
-----END PGP SIGNATURE-----
--=-=-=--
