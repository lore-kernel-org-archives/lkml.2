Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1F3E4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:56:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48801 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab1F3E40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:56:26 -0400
Date: Thu, 30 Jun 2011 14:56:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: strange commits in drivers-x86 tree
Message-Id: <20110630145617.c25910a9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jun_2011_14_56_17_+1000_vySsr+Mt.yA64w+K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jun_2011_14_56_17_+1000_vySsr+Mt.yA64w+K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

Commits dda10fb10f45 ("x86: cpu-hotplug: Prevent softirq wakeup on wrong
CPU") to c1ad45c0be10 ("Linux 3.0-rc3") in the drivers-x86 tree look to
be a cherry-pick of commits 842c895d140a ("Merge branches
'x86-urgent-for-linus' and 'irq-urgent-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip") to
2c53b436a308 ("Linux 3.0-rc3") from Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jun_2011_14_56_17_+1000_vySsr+Mt.yA64w+K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODAHxAAoJEDMEi1NhKgbsiDUH/1hwAS6O5jlmEax19K2PwlXJ
osqvCbHpxSK8Jx851/5qAfYZLG02Tu8nMJWXU7MA9FZsPCtSY8K69rKSVv5oonHU
Dcf4bAz4Cinj5dGdM0FZA6zjcXHW0p4+mcZeZ5KitodebjI1iS4iAlriBPxh0ceN
mGTt8/ULiYHwg3AYT4f+xBsLWSKvAvW2tMXYxQDjy1YOapX9VuYbOy9aQWWLyprK
xmHN/AN4sufnme9W6dC2XgBysKgQHZQE2JN/14GcRUncXREAYYMdl0CdVBbb1BGf
UB0/OhKIRBjnUSjV/nj2sNAJpe3UiYEtkbzfaht1/Cf9hEK+nO4v0qJFyii06Wc=
=1qps
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jun_2011_14_56_17_+1000_vySsr+Mt.yA64w+K--
