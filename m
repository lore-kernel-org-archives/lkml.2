Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab0EZUte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:49:34 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:54715 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab0EZUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:49:33 -0400
From: Eric Anholt <eric@anholt.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: airlied@linux.ie, chris@chris-wilson.co.uk,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] drm/i915: Convert more trace events to DEFINE_EVENT
In-Reply-To: <4BFA3808.5080203@cn.fujitsu.com>
References: <4BFA3808.5080203@cn.fujitsu.com>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Wed, 26 May 2010 13:49:29 -0700
Message-ID: <87ljb61j8m.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 24 May 2010 16:25:44 +0800, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Convert i915_gem_object_clflush to DEFINE_EVENT, and save ~0.5K:
>=20
>    text    data     bss     dec     hex filename
>   13204    2732      12   15948    3e4c i915_trace_points.o.orig
>   12668    2732      12   15412    3c34 i915_trace_points.o
>=20
> No change in functionality.

Applied.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9iVkACgkQHUdvYGzw6veu/wCglMzdQGrH+mDr3794IbvGtPco
/Q0Anjiy+tFmyG61bGFG/Fa50DGowZ2s
=WDSm
-----END PGP SIGNATURE-----
--=-=-=--
