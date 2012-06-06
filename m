Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2FFEu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:50:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38720 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2FFEuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:50:14 -0400
Date: Wed, 6 Jun 2012 01:50:07 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-06-06
Message-ID: <20120606045007.GB2533@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

We got a quite important fix for 3.5, a regression was preventing important
features of Bluetooth from working. Please pull. Thanks.

	Gustavo

---
The following changes since commit fcb6ff5e2cb83e1de10631f6621f45ca3401bf61:

  iwlwifi: disable WoWLAN if !CONFIG_PM_SLEEP (2012-06-04 15:27:07 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to ddcd0f41471a1e0394c8840a119ec3986a78462c:

  Bluetooth: Fix checking the wrong flag when accepting a socket (2012-06-05 06:26:26 +0300)

----------------------------------------------------------------
Vinicius Costa Gomes (1):
      Bluetooth: Fix checking the wrong flag when accepting a socket

 net/bluetooth/af_bluetooth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzuF/AAoJEPs3PUX4s20oEGEP/ihlMtjS5DdBBxIW00h0uJSf
+QnYwBtaT5+NpFXsdtzJdv8dVv9KJACh1OF18c4+MMzB0Zq/AR8LgXVCqmoL/dgW
jD2XEVtDOPN73SOvMi7J9ndOvruh14n2j4ap3eRfDme8lLizZ6cHeWKKozn7Fh4X
gi00vjt/6VptWKXLFaOLdTxcK1dy3HEOQroW2qxfwID/OR2fE/3jIlgKG2Mfk0K7
vtthCb1Ql76uHnzFMMo0uaBjnOVxXZzgG/1X+BzzYGZcja7B2Ir1ReH+DCJW2zT+
z2U0MVE8JxxuR9tlvoZghr3J6r9I74crClwoNLky/VKx699A2Mqs3T2DHFi85hRe
Ngjpjnq8x+9ZBuVWHqSf3YJRp1/gkktwfhf3WWd4klY7arf0lvayqVnBidEWGDia
LK9QxXXsmbboiohzIpi1JNPqsLCRg5QXOV2h564ly3n4hMG0DjsGWA0B3g0DkuC6
WJT6tjXsNuyKZ+bYf11XamTKy2+WVJT8GHUHoK9qW4a0JfPJMXXNKDDQ6xwOZgJZ
FNpifrfY9iGzd5edywGNjr80gTjWxDlq6U5IPYl611wtvoQFoR4t8oktnmZeztKP
kQhe/7CBIuEYf2Y/90t9BScIul6ilagG4RN2B8ybXfEiem/VeeWpI3zLoFjHNaZD
5WiUD+1h0Y3mzWg1O9lI
=3usZ
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
