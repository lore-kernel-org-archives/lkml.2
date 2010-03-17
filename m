Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0CQVJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:09:41 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:48004 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0CQVJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:09:39 -0400
From: Eric Anholt <eric@anholt.net>
To: Li Zefan <lizf@cn.fujitsu.com>, Chris Wilson <chris@chris-wilson.co.uk>,
       David Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] drm/i915: Convert some trace events to DEFINE_TRACE
In-Reply-To: <4B98ACC9.4080504@cn.fujitsu.com>
References: <4B98ACC9.4080504@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 14:09:25 -0700
Message-ID: <87eijik64a.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Mar 2010 16:41:45 +0800, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Use DECLARE_EVENT_CLASS to remove duplicate code:
>=20
>    text    data     bss     dec     hex filename
>   14655    2732      15   17402    43fa i915_trace_points.o.orig
>   11625    2732      10   14367    381f i915_trace_points.o
>=20
> 8 events are converted:
>=20
>   i915_gem_object:  i915_gem_object_{unbind, destroy}
>   i915_gem_request: i915_gem_request_{complete, retire, wait_begin, wait_=
end}
>   i915_ring:        i915_ring_{wait_begin, wait_end}
>=20
> No functional change.

Applied to -next.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuhRQYACgkQHUdvYGzw6vfnygCeNIEnkOao9mKW22SjLN9yS8U8
hm4An1svalZCU9RUU/e4DkhRhvft3k7R
=LsvT
-----END PGP SIGNATURE-----
--=-=-=--
