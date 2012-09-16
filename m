Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2IPMeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 08:34:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2IPMeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 08:34:00 -0400
Date: Sun, 16 Sep 2012 14:33:54 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: fixes for v3.6-rc6
Message-ID: <20120916123354.GA25130@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:P/HffI9loszN3da6Rgll8J35t8Pn8Iy03dOKOv7fOsp
 pZjUPjiJ7ldQ0KcC205ztmrvCpTlynSEJVoP7cH+zPfpcwsfBf
 xKnSQ6wKucEqlCK7CfF4n9KAYXQvNJbgbVYHpLdNjRKV7Bovsz
 0hxjsUQ0a+dWHLcLZKIPAcDoVhp7Ex9it5eQPLRrgStQAxtCJN
 OtcYZKcpwZNXOd5I0AuQ4X8sT2tkZP3w2iVFwT2UMLrkWXOdkH
 m2E2ACLSpZnKHCkObf2zPpzH1EIEB5nazx9DwCxqWHPwvhotjE
 w83XgR4ZE8f2IVPExK8sWycoLBTgUaKLYMX0B2Dzo8BUxFCPCa
 VbqVWgC0xGg/gtBro3Pbci5vcPVNgczYfHMochzpFFNb+zDA7w
 ESXrxo6bWAAKkTF5Tv3RmgxoROuMvc3RSmBX96aVjlKzwP4zUL
 Pauta
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit b817bf5c72774556345a9043c6b0c497cdcb7295:

  pwm: Improve Kconfig help text (2012-08-20 11:58:43 +0200)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.6-rc6

for you to fetch changes up to 01b2d4536f0215c6d97d77e157afee04300ffc90:

  pwm: pwm-tiehrpwm: Fix conflicting channel period setting (2012-09-10 17:04:38 +0200)

----------------------------------------------------------------
While this comes a bit later than I had wished, both patches are rather
minor and touch only new drivers so I think these are still safe for
merging.

----------------------------------------------------------------
Philip, Avinash (2):
      pwm: pwm-tiecap: Disable APWM mode after configure
      pwm: pwm-tiehrpwm: Fix conflicting channel period setting

 drivers/pwm/pwm-tiecap.c   |  7 +++++++
 drivers/pwm/pwm-tiehrpwm.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQVccyAAoJEN0jrNd/PrOhTnoP/0UoCOBUAQauGHxMsKOrM0TR
TzNcQoobetkZF/1vcGRjOy2Ebh/UZS6hStRz+kJ6M/7Uzil9r1ZReOyOyKHF3fs9
4j5sbivJ+P0u/Ncx/ZkjPFWxIEsLkGKSnyiXMM8f8sPiSYg3fpAVxQFSypgmV1mO
0Ge3DI31YFA5/33yKj9kJHhYOfKcgHHl+RG2yyspPeD8fWV2TYGiFzSWuDFHb3Zz
QDlR9H+tPZsucf4djrfmbRPAF3D2mRpKTQEaUvl2q6wrFsZU8AOaRzNbhS1ibhsO
4PJIDBEojzrB2XTw0XnIEtKK0bf93dfrEa3fcdZJsTKw4PpwIo2uK45fmU0BdhEV
ix8guLnD6/DexHdVg24Mpg+bNHs5V6xjZrjoKwD4iv5gosURTgnQXQ6JaYSo9X5G
gf3KN/XFh1DM6SpCZAIhHFXN1joYtpiCQCOQ6Z+tJ84Eoy6dL12pDjCNdKgz231t
c1bXMMe741Itu+WboiZo2fkcEFXY5HQWLJvq4G17gGCNsVDPYIxts4nGCk2cfSVs
2NFovHHBIHJ4gup8mgplv2jC0fFWK20ygSqmbJLaHZc5AUIvIVGpIgQpMBbtBHuH
RtWwe3C2NTlMUuRCXeSR6cBZGTap7l+zWycaExc4A5YkqH6TcBAlOPN9lcpWc2PN
ZOECwrYk2alzTn5u5BO1
=1MXW
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
