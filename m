Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1KYR4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:56:20 -0500
Received: from home.keithp.com ([63.227.221.253]:33107 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab1KYR4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:56:19 -0500
From: Keith Packard <keithp@keithp.com>
To: Patrik Kullman <patrik.kullman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915: 3.2 rc1/2 KMS regression
In-Reply-To: <CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com> <861usye0og.fsf@sumi.keithp.com> <CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 25 Nov 2011 09:56:27 -0800
Message-ID: <86sjlccchg.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Nov 2011 18:29:31 +0100, Patrik Kullman <patrik.kullman@gmail.co=
m> wrote:
> Ok, so I've now bisected, and it turns out that
> dc22ee6fc18ce0f15424e753e8473c306ece95c1 is the first bad revision.
>=20
> Would it be safe to checkout 3.2-rc3 and git revert
> dc22ee6fc18ce0f15424e753e8473c306ece95c1 (to test that it's the only
> bad commit) ?

Yes, that would be very useful. Please send kernel logs with drm.debug=3D4
for an older working kernel, a broken kernel and a patched
kernel with this commit reverted.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTs/WyzYtFsjWk68qAQiYjBAAy+j23exexzClHOBAGOZCTkyPcaNAr1tp
sbKkG3MBTLexhZyJjPU4X1z7XeDnDd0HHPDJ/th7LzCC9EAYcptcBBntrFbywC8g
CLOWo3mVcQZcPsvUBVIdWOc3U3EWFhrnQZLWkfbQyhSPDTlu008/cOtij0n3PMey
F0koRfPTWUOzE3c+yQ3LYKadyopBsbNT/Paoh0fEQaJc/weaoiKz8sH9HOWVNvP3
ROiojo+Zid+Swq6+WV+ZKqwB+q1hzYdbfnhWL6Np2qsMRSXim/mYGqa1pKqjqxjW
wXeGry3Ew/t5yyNP+5gd+fPrhovVoJEcl22fSlqLdb78uPSnI6JkocOgtWdSZDmU
DYK7lLR6qetkAsWyRerrQgQf4I/kXYss86tvT1kc79l7zTxV6vLudRjnmuSkyBoP
OQoaAF5xJMgsZzyfn67xujXO3K2dy7fhJS9gG0r7usun936ZCB2MaNBQQFTkna1U
gDrOdWzONZ+7jHZTGb/1siitLdjwHuV+wQ+Pnua2nw2Bys+seSO3b/9FXJjlqt/W
kw5doU3NaO9VJz2pmg4r5SOIY0W3ukgRwPYAkZqohxWe0d7lcqYPKXpWtUCBOhgA
Anxmzzf6d+zMpocp7+LRPYfi+QG0BNrGBNpPtsU7Q18PLBhChBoOHSLXh7XZfbyk
6T521LCI1qc=
=Jbil
-----END PGP SIGNATURE-----
--=-=-=--
