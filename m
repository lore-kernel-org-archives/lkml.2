Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1FBXpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:45:06 -0400
Received: from home.keithp.com ([63.227.221.253]:49278 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab1FBXpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:45:05 -0400
From: Keith Packard <keithp@keithp.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] drm: i915: correct return status in intel_hdmi_mode_valid()
In-Reply-To: <20110530124826.74d83b35@absol.kitzblitz>
References: <20110530124826.74d83b35@absol.kitzblitz>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 02 Jun 2011 16:44:42 -0700
Message-ID: <yun8vtjyf11.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 30 May 2011 12:48:26 +0200, Nicolas Kaiser <nikai@nikai.net> wrote:

>  	if (mode->clock < 20000)
> -		return MODE_CLOCK_HIGH;
> +		return MODE_CLOCK_LOW;

Seems obvious to me.

Reviewed-by: Keith Packard <keithp@keithp.com>

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN6CBqQp8BWwlsTdMRAhgQAKDqeGTXykUpS8adZZKr640Dg4aAxgCdEbhc
kJhe5wRfkU1XTS0yNBAmP5I=
=6qYQ
-----END PGP SIGNATURE-----
--=-=-=--
