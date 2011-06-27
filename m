Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1F0XZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:25:35 -0400
Received: from home.keithp.com ([63.227.221.253]:59898 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab1F0XYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:24:48 -0400
From: Keith Packard <keithp@keithp.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: i915, framebuffer: wrong xoffset?
In-Reply-To: <BANLkTikhFyR9c6UfJX2oTdWq9crb9M73Ow@mail.gmail.com>
References: <BANLkTikAJEma_NNi0NYnjBEB6RkFJK3Dpg@mail.gmail.com> <yunhb7ckxtl.fsf@aiko.keithp.com> <BANLkTikhFyR9c6UfJX2oTdWq9crb9M73Ow@mail.gmail.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 27 Jun 2011 16:24:44 -0700
Message-ID: <yunhb7aj1s3.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Jun 2011 19:17:48 -0300, Lucas De Marchi <lucas.de.marchi@gmail.=
com> wrote:

> I've just build a new kernel and noticed it's fixed in current Linux
> tree. Since -rc4 still had this bug, it was very quick to bisect this,
> and the fix was this commit:

It doesn't entirely make sense, but then we don't know why this call is
needed for any hardware, so it doesn't surprise me that this fixes your
problem too. Good to know, and thanks for retesting.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOCRE8Qp8BWwlsTdMRAr+6AJ9/1nFSP+d0xmzdsCFpUfb3GFMO9ACg0xTE
hAIj0jVvi4kWYvfIl+H6DBk=
=M9ES
-----END PGP SIGNATURE-----
--=-=-=--
