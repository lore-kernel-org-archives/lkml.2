Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2G3T1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:27:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27328 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2G3T05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:26:57 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=fkZsc03rGQ4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=4cyUyEd3mB8MIem1ErQA:9 a=QEXdDO2ut3YA:10 a=4OmSZb3QM2sOMBr5lawA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120730192314.144253843@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Jul 2012 15:23:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 00/10] [GIT PULL] ktest: changes for v3.6
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Seems that you opened the merge window the day I left for the beach.
I just got back (yes us Americans only take a week vacation), and just
got the last of my ktest quilt queue into git.

Please pull the latest ktest-v3.6 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.6

Head SHA1: 25758cdd91fef784cd5e13aa0580592250a0a5ab


Steven Rostedt (10):
      ktest: Remove commented exit
      ktest: Add PRE/POST_KTEST and TEST options
      ktest: Add PRE_INSTALL option
      ktest: Add CONFIG_BISECT_CHECK option
      ktest: Fix config bisect with how make oldnoconfig works
      ktest: Add MAX_MONITOR_WAIT option
      ktest: Add check for bug or panic during reboot
      ktest: Reset saved min (force) configs for each test
      ktest: Ignore errors it tests if IGNORE_ERRORS is set
      ktest: Allow perl regex expressions in conditional statements

----
 tools/testing/ktest/ktest.pl    |  167 +++++++++++++++++++++++++++++++++++=
+++-
 tools/testing/ktest/sample.conf |   52 ++++++++++++
 2 files changed, 215 insertions(+), 4 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQFt/8AAoJEIy3vGnGbaoAKe4P/iCPoajkd5zJDhIKVOFp+qdT
YeqE0e6pz60dds6lHocwyjq7PFEiBygdkNW65zaUxyCUxNtiEIHToRTZelTZh8l+
f0QXy/YK+eh6IuA8M6nWwFkW67QLIzKLzZrIPsefKC5bD5X6cClx57ylqpuMvUfs
76lW0GDT1MRe1HIJrxV1gGLVIZd7CIRKl9Z3mOzVL8DuRRe9hAbYbKaVNRkz3vqo
pLB3awc4cx4GObFucni+E7doaq8SjNAzL25vapbD8kZ7akpWpHhlXcDs6YTWJhfw
4fjWzuynhvBDGV4YtsCaMNYG/lGeTfUh/tLPaRn2u/PC13oByuJqtSjJxJ+3uU7z
m72uAe3xEw+z+NTtm7B8/vKCAbW4tWikzcOC8kK1Z88p+U/v5xQ54gy/tLQ+Bzn+
yOBHSnMVQkS+T0+FQiDwebJiFjBmJJpt0CN+ZYrHxFlvaM58Zb88wqxC54+zSEn4
LZVSRRNvOAKctbVPGTzr4N72VL9dbrEDKvVh/Lbt8UCFGZlSFAxXGbjjngg3OIOZ
9kncWlHYuEMHF8V2preWq4bgAO7WpTlaKt7XEenmULQNKYQo7ABQO1GfDUErqqCb
xAZ/r+QhVBoyiijJl18y5TkLLuiwwRkDLolBG0QTbVciQgjCbk53IkiCRt+0AwwS
+HUbSGfOdKnz1/gwckg4
=E3cG
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
