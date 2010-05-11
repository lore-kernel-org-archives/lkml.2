Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab0EKCry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:47:54 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:34952 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab0EKCrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:47:53 -0400
From: Eric Anholt <eric@anholt.net>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [003/117] drm/i915: Add initial bits for VGA modesetting bringup on Sandybridge.
In-Reply-To: <20100510223317.484832756@kvm.kroah.org>
References: <20100510223317.484832756@kvm.kroah.org>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Mon, 10 May 2010 19:47:52 -0700
Message-ID: <87hbmfm9wn.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 10 May 2010 15:31:34 -0700, Greg KH <gregkh@suse.de> wrote:
> 2.6.33-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
> From: Eric Anholt <eric@anholt.net>
>=20
> commit bad720ff3e8e47a04bd88d9bbc8317e7d7e049d3 upstream.
>=20
> [needed for stable as it's just a bunch of macros that other drm patches
> need, it changes no code functionality besides adding support for a new
> device type. - gregkh]
>=20
> Signed-off-by: Eric Anholt <eric@anholt.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

This patch should not go in stable because of this hunk:

> --- a/include/drm/drm_pciids.h
> +++ b/include/drm/drm_pciids.h
> @@ -560,4 +560,5 @@
>  	{0x8086, 0x35e8, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0x=
ffff00, 0}, \
>  	{0x8086, 0x0042, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0x=
ffff00, 0}, \
>  	{0x8086, 0x0046, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0x=
ffff00, 0}, \
> +	{0x8086, 0x0102, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0x=
ffff00, 0}, \
>  	{0, 0, 0}

Without that, it would be fine.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvoxVgACgkQHUdvYGzw6vfv4gCfdMBPPx3PAgJmmFsW/oy6TeT+
WZwAn2fIqJ/0klBOV91gV0W9ClJZFWYS
=fT3l
-----END PGP SIGNATURE-----
--=-=-=--
