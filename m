Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2JMC5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 22:57:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37623 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2JMC5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 22:57:22 -0400
Date: Fri, 12 Oct 2012 21:57:18 -0500
From: William Hubbs <w.d.hubbs@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: question about /dev/root symlink
Message-ID: <20121013025718.GA29450@linux1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

All,

I am part of the team that maintains udev on gentoo.

This bug [1] has prompted me to ask a couple of questions about the
/dev/root symbolic link.

According to upstream udev, we should not use this at all and if tools
are relying on it they should be fixed to not do so.

Does the kernel create this symbolic link in devtmpfs as suggested by
[2] and [3]? If not, should I be writing custom udev helpers to create
it?

Thanks much for your time,

William

[1] https://bugs.gentoo.org/show_bug.cgi?id=390519
[2] https://bugs.gentoo.org/show_bug.cgi?id=390519#C20
[3] https://bugs.gentoo.org/show_bug.cgi?id=390519#C26

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlB42I4ACgkQblQW9DDEZTgLtACeLF+KTQr7lAuZgZg6bjm7H3xg
MQgAoL1Ek2MeT3Bd7h4FDFQW/vqLH2OT
=HW1F
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
