Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1I2FSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 01:18:49 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49100 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1I2FSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 01:18:48 -0400
Date: Thu, 29 Sep 2011 15:18:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the regmap tree
Message-Id: <20110929151841.1ee572099f6bc4db67138825@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Sep_2011_15_18_41_+1000_gHBEfJYgt335IHsf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Sep_2011_15_18_41_+1000_gHBEfJYgt335IHsf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the regmap tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/base/regmap/regcache.c: In function 'regcache_cache_only':
drivers/base/regmap/regcache.c:276:2: error: 'struct regmap' has no member =
named 'sync_lock'
drivers/base/regmap/regcache.c:278:19: error: 'struct regmap' has no member=
 named 'sync_lock'

Caused by commit 38f6916976f9 ("regmap: Grab the lock in
regcache_cache_only()").

I have used the regmap tree from next-20110928 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Sep_2011_15_18_41_+1000_gHBEfJYgt335IHsf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOg/+xAAoJEDMEi1NhKgbsoVsH/3EDtja3JBYtw7xqPJGEIk2k
kg+eRW6xhghy+Tua1M6fNh6HYiCAVyNJoVPfnAbEespPmN7HXBWkifqQWJQOFLAj
00YaR78vhz3rYFOn61cdWcaei0QI9fsG3oTl+M0xZ/6PLRCJq6xsRQ0VZNeTdFsu
pLx1vlEj/23hV3vIpAKxS2uVfja5opdc27TMhyfiDisktWLdRoHuvJUvujm5RZXb
UnpKAFK5v9kgkno84jipK09iRI482BeLYjg2rTDPYkv7cS5n5cAlRjRZTmlWtp4V
jziUxtD0O2AJE+X1XQ9xvVQB7xgyPzQ4ANrOIyv1xxRlI3IACIUtPiTp8HPLCkQ=
=MiHZ
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Sep_2011_15_18_41_+1000_gHBEfJYgt335IHsf--
