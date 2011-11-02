Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1KBVB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:01:57 -0400
Received: from home.keithp.com ([63.227.221.253]:56499 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1KBVBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:01:53 -0400
From: Keith Packard <keithp@keithp.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, francis.moro@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        francis.moro@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Subject: [REGRESSION]: Resume fails with 'perf: Add PM notifiers to fix CPU hotplug races'
In-Reply-To: <tip-1cvevybkgmv4s6v5y37t4847@git.kernel.org>
References: <tip-1cvevybkgmv4s6v5y37t4847@git.kernel.org>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 14:01:48 -0700
Message-ID: <yunaa8eutkz.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Aug 2011 15:52:52 GMT, tip-bot for Peter Zijlstra <a.p.zijlstra@=
chello.nl> wrote:

> Commit-ID:  144060fee07e9c22e179d00819c83c86fbcbf82c
> Gitweb:     http://git.kernel.org/tip/144060fee07e9c22e179d00819c83c86fbc=
bf82c
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 1 Aug 2011 12:49:14 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 14 Aug 2011 11:53:03 +0200
>=20
> perf: Add PM notifiers to fix CPU hotplug races

This patch causes two of my machines (Sandybridge MacBook Air and
another Sandybridge desktop) to fail at resume time.

I reverted this single patch from Linus'
37be944a0270402f9cda291a930b0286f6dc92f5 and both machines resume
correctly now.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrGvvDYtFsjWk68qAQg9KBAAxVJjRi87+3RJcTYiev2w3pY8IT83VtZj
hPB3sW4DUykGN1fO+DHObKE3R43GhV4L42g3eKXuLqL52ASMDcseMJ51TGJPntgD
kOj7DDBV5NQayu7YfP8cI4Zo3R7TonRLgj/S6rp8Uel6VRK22tvH8cn2shEx+M8t
vY3bR5g3Oj+Yoz/n1Of5OBOxyZ69fys19wAtD1YmvyFoJWtN/NWmI3TXWhtn7Qbe
JP0WTUuc+yCvc18Z2dr849RVco7TBkDoJvdntMpJhLTUs8aOAGWwbL2TqZ4ofhK+
FjpCBzWskezPrk2ZG7tI1CFhIM2ihEQ9Gp/Mm3szLQEQtHQLkow3tp9nFc2LbcfL
0/udsGkytmhAtOx1KKtRoFOSKC/LwtNHMTAlQKLDWTjY6cGoI7HeJ+FU+6lK6XcT
PI2qC9IZdbzY/0JkX61yqrJahsy2Rs/JeOzGky9dxS2nfKxXYFmlqc+qq8pUZ/4S
VVubdKzV+AIVFSURIFOa91Drx36ecYIBVNGgqgrA+arzXF/x9O7O10qqHhLAvEao
Xso/+Iuzo+KMg15SUbkCE523ujEkv4K7/h+CMMBeuPp0APCm65VvGE8jXU2A1yjI
8tMVYj2s4yPuaaCXw0KoyWgPSs24R64uh6hOdVvOEyXSygYjgefZUkaq/qIDbLmo
L3P/qbd4TtI=
=s8EX
-----END PGP SIGNATURE-----
--=-=-=--
