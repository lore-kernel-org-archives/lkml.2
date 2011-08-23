Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1HWFPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:15:33 -0400
Received: from home.keithp.com ([63.227.221.253]:43246 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1HWFP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:15:27 -0400
From: Keith Packard <keithp@keithp.com>
To: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: 3.1.0-rc3 -- WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x92/0xa6()
In-Reply-To: <CAHFgRy_-=6re9DhGywq4CaQFc8Gv57R1NFa3mUtNbShBA73NtA@mail.gmail.com>
References: <CAHFgRy_-=6re9DhGywq4CaQFc8Gv57R1NFa3mUtNbShBA73NtA@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 22 Aug 2011 22:15:17 -0700
Message-ID: <yunobzg674q.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Aug 2011 01:04:49 -0400, Miles Lane <miles.lane@gmail.com> wrote:

> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x92/0xa6()
> Hardware name: UL50VT
> sysfs: cannot create duplicate filename

Can you try drm-intel-fixes from my linux-2.6 tree? It's got a patch on
top of -rc3 which should fix this.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOUzdlQp8BWwlsTdMRApnEAKDOC3Jlta8kJLsLbAdwi/K1qAh0EACfSsJg
V/TK/Ko5/8i8ZkmXPzc79/8=
=rKOU
-----END PGP SIGNATURE-----
--=-=-=--
