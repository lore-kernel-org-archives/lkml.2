Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2AIRWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:22:55 -0500
Received: from home.keithp.com ([63.227.221.253]:43754 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab2AIRWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:22:54 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Michal Marek <mmarek@suse.com>,
        "intel-gfx\@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH] drm/i915: set AUD_CONFIG N_value_index for DisplayPort
In-Reply-To: <20120109131717.GA4713@localhost>
References: <20120109131717.GA4713@localhost>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 09 Jan 2012 09:22:47 -0800
Message-ID: <86y5tgx02g.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jan 2012 21:17:17 +0800, Wu Fengguang <fengguang.wu@intel.com> wr=
ote:

> +#define IBX_AUD_CONFIG_A		0xe2000
> +#define CPT_AUD_CONFIG_A		0xe5000

These register addresses match the docs.

> +		I915_WRITE(aud_config, 1 << 29); /* N value index, 0x1 =3D DP */

Please don't use constants here, instead add #defines for all of the
bits in this new register, in case someone else needs to use the
register later.

Do we also need to program the pixel clock values in this register?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTwsiZzYtFsjWk68qAQhHbxAAnE5mKwlIYIECkcRHxJVVbocEUFJnXn+4
e8c1iL14K4YoZBWDSUtoIeGtfezbcyAygPkXcb1lmdaxXvQRfxRRUhbx4AgaqVmK
vmsLPvpcI/Y0E9ZCxLyLiEmmdjcahLrp+3ZEd0+zMsFRrm55mnif60om7B9hXs5K
dRnLnKqN7FTygKeXg0OnnTJsJOPAZBIokDm08/x+Tyj950yC+JUWL++zI3MlZ1dU
cZhqY+ueTUI56xqEWXUOnQjjc1NhQty3udLsfp+1F5kL9ujjf9sacYHKJjtZwdGX
HJVMGnzVP7tolrEPfAmts3WZHFRg+5QqUHdfoIbvycUZsNIQsmqcy0un89yEHqgu
HOb7imaKERiC/TqxvkHHY1IswTv76M13trR8wsOpTTv2HXwftxV6FgvpNlaEZ0UV
p337qL0mAi1NPW2N4Xkz2CdMSVTIAtfRZOMhYF2T/pvISR0qPFruh93wWmlheJk+
+U5GJDqe+aTsvRz/ToVY5+RHnV2AOH6Ou8PEjwV9O0pQVivgroi98UxIVB6RALx4
+2onARq8SF2EmMaxuxbfDtZJC59ZEDAKpJVRXVTpGX+4Ry2it++e07WU4Rr2sElv
MpWbJNt7iQdwUn047RVg9CVGy6HX9w3z3gQP3a2uPI5Yg7X6UQtJye3M2MdpuHa2
/snw3aKZx9I=
=+VEu
-----END PGP SIGNATURE-----
--=-=-=--
