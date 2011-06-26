Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1FZW5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:57:05 -0400
Received: from home.keithp.com ([63.227.221.253]:36197 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833Ab1FZWzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:55:06 -0400
From: Keith Packard <keithp@keithp.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>
Subject: Re: i915, framebuffer: wrong xoffset?
In-Reply-To: <BANLkTikAJEma_NNi0NYnjBEB6RkFJK3Dpg@mail.gmail.com>
References: <BANLkTikAJEma_NNi0NYnjBEB6RkFJK3Dpg@mail.gmail.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 26 Jun 2011 15:55:02 -0700
Message-ID: <yunhb7ckxtl.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Jun 2011 13:29:47 -0300, Lucas De Marchi <lucas.de.marchi@gmail.=
com> wrote:

> Since 3.0-rc1 when booting my computer the text in the fb console is
> displayed with a wrong xoffset. I took a picture (sorry for the poor
> quality):

Can you capture register dumps in the working and broken configuration?

git clone git://anongit.freedesktop.org/git/xorg/app/intel-gpu-tools

Build that and run tools/intel_reg_dumper and send along the output of
that in working and non-working configurations. That should show us
where the problem lies.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOB7jGQp8BWwlsTdMRAmRnAJ44Ub0zbd0qXAAzBGwDj97h2GbxCACg5tL3
Y7Pnemc/4eDkBHidORG5l1I=
=nwaB
-----END PGP SIGNATURE-----
--=-=-=--
