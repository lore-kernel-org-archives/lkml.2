Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0EZTBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:01:00 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:47964 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0EZTA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:00:58 -0400
From: Eric Anholt <eric@anholt.net>
To: rostedt@goodmis.org, Li Zefan <lizf@cn.fujitsu.com>
Cc: airlied@linux.ie, chris@chris-wilson.co.uk,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] drm/i915: Convert more trace events to DEFINE_EVENT
In-Reply-To: <1274818126.22648.221.camel@gandalf.stny.rr.com>
References: <4BFA3808.5080203@cn.fujitsu.com> <1274818126.22648.221.camel@gandalf.stny.rr.com>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Wed, 26 May 2010 12:00:55 -0700
Message-ID: <87bpc2lc7s.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 25 May 2010 16:08:46 -0400, Steven Rostedt <rostedt@goodmis.org> wr=
ote:
> On Mon, 2010-05-24 at 16:25 +0800, Li Zefan wrote:
> > Convert i915_gem_object_clflush to DEFINE_EVENT, and save ~0.5K:
> >=20
> >    text    data     bss     dec     hex filename
> >   13204    2732      12   15948    3e4c i915_trace_points.o.orig
> >   12668    2732      12   15412    3c34 i915_trace_points.o
> >=20
> > No change in functionality.
> >=20
>=20
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>=20
> I'm expecting that this will be going through the DRM/i915 path.

Yeah.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9b+cACgkQHUdvYGzw6vdxbACdF6chPVnuc2k0q8CJmG1hT3Vv
JZQAnit0uPphvLnHaDkNXWJMuMK4Nw/J
=ZeFY
-----END PGP SIGNATURE-----
--=-=-=--
