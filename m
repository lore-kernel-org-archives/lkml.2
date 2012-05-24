Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2EXHVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:21:35 -0400
Received: from home.keithp.com ([63.227.221.253]:57011 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab2EXHVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:21:33 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2012 03:21:27 EDT
From: Keith Packard <keithp@keithp.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, Bdale Garbee <bdale@gag.com>
Subject: Re: [PATCH] acpi/video: Don't restore backlight to 0 at boot time
In-Reply-To: <20120103221954.GA2313@srcf.ucam.org>
References: <1325321547-20637-1-git-send-email-keithp@keithp.com> <20120103221954.GA2313@srcf.ucam.org>
User-Agent: Notmuch/0.13 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Thu, 24 May 2012 00:13:40 -0700
Message-ID: <86ehqajbkr.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> ACPI arguably does define 0 as being off (this is exceedingly poorly=20
> defined), but I'm not entirely happy with this - the firmware makes its=20
> behaviour conditional on the OS version. I'd really like to see an=20
> updated version of the Intel opregion spec to get a better idea of what=20
> we're meant to be doing here, but the last one made public was
> ancient.

Kernel 3.4 continues to break on this machine; I'd love to know how to
get a suitable fix upstreamed...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBT73fpDYtFsjWk68qAQgCRRAAwaguppWlV2hNWnk0vMFdPZKBArdj9diD
O5yo4chRPYeK0RO0SC/aCniVi9/vEbt/jQOXIiVC4bHPCha6SigOHyHTMdMu8NWI
wcA37dRWUTmfhc3EVuFRwJFJ/J+6N0qc+MrpQ3sAZdtF9DWWl6yJ15oZr+l7baeZ
vYvMk+jyd6E06bRcE3+NG/9tFZPjPrcm+WjgolkKZzMZtKOegDlSCDFPi2OJHAyX
rSYAEYZXLpkmjZkqx6YLhRdSyIw/0iTnSmv0Lo3OBwUnH7JZ54h/9VSUKz3dQNRp
X18MePx+3rTWzUjSdpZFF5MEqEr/4nr9bCRiksmezVldTzSZhbIgnjhYndYTbfPX
N4/ACzK1GunX3eC3Kqp1SjVVBjdwlz3/gTGJyNfG7yc/OuQqoHKAMKn7thqF7tCm
f/p5A/BYmPXiz/KVNldoWgXStwpquiHjkAdg4sDgfiwac3r0G3IdSmL9m5JJx/7U
xc38v3mn8DgM9zkpH3ijXwRI2qoq/cTlPitaovPXRY5rhSYw3Y3+dI67GkWexJa5
FqxlJ3VUiafB15gzni9JlqOp2cBhJPwRsmA/rXsqNTuwdJJy/yW3tgVTssNx6NJt
r16ka7+CIioHnIam1FGJbrY8kT5xMdNpIj8qXmR5V+gqU/JnVHE6A4TgmTEba/12
GNmzOcnLbpY=
=cymY
-----END PGP SIGNATURE-----
--=-=-=--
