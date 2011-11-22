Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1KVSZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:25:15 -0500
Received: from home.keithp.com ([63.227.221.253]:60931 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1KVSZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:25:14 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang\, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 v2] drm/i915: hot plug/unplug notification to HDMI audio driver
In-Reply-To: <20111122074055.GA21560@localhost>
References: <20111121063749.GA23450@localhost> <86hb1xife8.fsf@sumi.keithp.com> <20111122074055.GA21560@localhost>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 22 Nov 2011 10:25:14 -0800
Message-ID: <86sjlgf20l.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 15:40:55 +0800, Wu Fengguang <fengguang.wu@intel.com> w=
rote:

> So the v3 patch will behave equally well on KMS console, gnome desktop
> and bare X. Shall we just use it, or go back and use the original
> ->hot_remove patch?

I'm not sure why we need any change to the core DRM code. The HDMI and
DP drivers will be told when to turn the monitors on and off, and that's
the appropriate time to control whether audio is routed to them. Hotplug
is considered simply a notification to user space that something has
changed -- user space is in charge of configuring which outputs are in
use.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsvpCjYtFsjWk68qAQhnUBAAuRqjcs1BcRl4t/6ELWwHmx8C8zwgGfzR
cT6FDUM9s09T/Qm+4aLQI+NZQkjBknyi6zU6jCl3T3NE/peWh/Fdh7w6w5RT+Ybj
L/bVclpWX8ULduNJWjauWSWeSzCQJxP7O8UKyKt+wwxmsGm5ONnXMMkPIxOzcikH
gyv4JVJs3nXn/c0CECSlxDEt6/tXVGZvwCFODUrtahQFdvWx0TkSNInDpZ6n+UbX
O9G1GQj7ANuxTuquBT9IKWvz0nBQXK4U+9F+h8Vj3HxV7FEdHebE5RZDCZ2vWhhp
hC0cxP0qnI7MJaw+s/SrfJBi0oK0sNZRBns3GyJ+sQq5v2PlVqcAGA4ATkW43QZB
8X25JAZQkVgzWm95/8ZtTZp/3vVGyM9EQHNudAqzMitSKEm75d96jPYQYwC8qzpx
/nr13a5wW8aAHJnDyhWLLNTo8Q3rM/HRM9vOT55zVtV3qfgVR7BOcV3gZ9/iCq5B
HvRjEEhDmb5yZDKIy02VAH3CFIwVwgGGHAT9sgvQipB1M+uTtSHwH7WxSjU1CLIl
m+yjm7ND0t9UCNv0TAPNwMPD4bXrgYa+HgjqXHRqmM3d2VusJKJtACfBf6i52HyL
O4mQ5e+38Iu5SIwCdPHFOH4+yfS8QHv32rDpjftzr47yVnQK1N9plOTXCYb7KKGH
I/kOkIyl//4=
=BpwT
-----END PGP SIGNATURE-----
--=-=-=--
