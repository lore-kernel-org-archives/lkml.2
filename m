Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab2AUSP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:15:29 -0500
Received: from home.keithp.com ([63.227.221.253]:35375 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2AUSP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:15:28 -0500
From: Keith Packard <keithp@keithp.com>
To: Lubos Kolouch <lubos.kolouch@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
In-Reply-To: <jfe47e$5dn$1@dough.gmane.org>
References: <jfe47e$5dn$1@dough.gmane.org>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 21 Jan 2012 10:15:24 -0800
Message-ID: <86mx9gkjlv.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 10:32:14 +0000 (UTC), Lubos Kolouch <lubos.kolouch@gmai=
l.com> wrote:

> I git bisected it to commit
> cd9dde44f47501394b9f0715b6a36a92aa74c0d0 is the first bad commit
> commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
> Author: Adam Jackson <ajax@redhat.com>
> Date:   Fri Oct 14 12:43:49 2011 -0400

Did you try reverting this single commit on top of 3.3-rc1?

And, can you collect the dmesg output with the kernel parameter drm.debug=
=3D0xe
added to the boot line, both messages at boot time *and* messages during
resume would be needed. If it works at boot time, I'm quite surprised it
somehow doesn't work at resume...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxsAvTYtFsjWk68qAQhjQhAAxCzTz3OY1LJeri1SyMOYFz2Cgie4t3H/
IZqsjmXHNLDuBeHrMrmmYXBjGq+RsXaTNFDsQ59gzSqJUESufvxKFtUhH8WH+oTA
spqpgcDWAenErWZieruZ+WgkQLPDQvwOZM/k87KeMp4kq87gwxciQ1Y4lYahIAQe
Ij2QUO6zWwvFALr0k8CiM6f7vfl+rPeEiM5hkA+Sm2LZ3L8eixzMQtsAyeGiLotf
+JQPZ9nzsHB91YzK+IsdVuVw/VW16wyTQAnXYY3++2Xh/yol4elKiALUXo0xcOwZ
8Ur9+8zm8GisdupFTc1L5Ou7BeZ2nz9DoVL1QMPQSSkqZpSwmOKrYr/qzGzMHU8B
ud4Dd/FxThYQVYQRGLbXzjTCYcE5Jv14ys6a7o9Rja91YtFzlZ/9H2qVozgzFkKT
dBHtqgFdZNTa17yho4CPuYLnT683WDxspE3C0y5hGyp/z2JlLZJY9dvGFYjPr/+A
ZRvIh/NdhEkRo/3PHt2PR7mGqdFJam7xFt/MwPTYY1+kvy5qB9LQOraa9w4UDfmF
UlwIFfrc+/JLeL/nnMK5cNtbb7izNtcrapeCpjygzH7q8cNSnRcF13ojauVGXhfe
h3aKwPpZPKzlw/vLWp5drYBMNG7HocFJF4o6fHfdnW19O3v315KGQU5FvZnJsd5j
b9VWajMrkSk=
=5dnL
-----END PGP SIGNATURE-----
--=-=-=--
