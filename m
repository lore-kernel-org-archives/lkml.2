Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0I1Diw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 23:38:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59425 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897Ab0I1Div (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 23:38:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Date: Mon, 27 Sep 2010 23:38:19 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; x86_64; ; )
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Alek Du" <alek.du@intel.com>,
        "Richard =?utf-8?q?R=1B=24B=EF=BF=BDK=1B?=(Bfors" 
	<richard.rojfors@mocean-labs.com>,
        meego-dev@meego.com, "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, andrew.chih.howe.khor@intel.com,
        gregkh@suse.de, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main> <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com>
In-Reply-To: <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2520623.MFD1FMnYhI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009272338.23762.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2520623.MFD1FMnYhI
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday, September 27, 2010 23:21:10 Masayuki Ohtake wrote:
> > You should be implementing support for the device using the
> > standard interfaces used by the other GPIO drivers in kernel.
>=20
> We are now modifying our GPIO driver with standard interface.
> I've got a bit of problem.
>=20
> I don't understand how userspace accesses to the driver.
> Let me know how to ? sysfs only ?

sysfs only.  look at GPIO_SYSFS in drivers/gpio/.  support the common GPIO=
=20
framework and the userspace API is taken care of for you.
=2Dmike

--nextPart2520623.MFD1FMnYhI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJMoWMvAAoJEEFjO5/oN/WBiakQAIoKQjGhvEVeysE34hrHJlCj
x0mK1rAni+hwV1hWMwZRY8cpnXkUEGyKqAylaj4v6++RTvp3HDpJ+umbWX2hkokm
/nt6WJsBpSUj27QLw7NTBfgWqFjgb2jyuETZB5kkeI27HiMJXPK1SkhvbWD+TqNt
lpjJusxBDzcO/anVQyQNVQaN+ZIim9ibO3pzalFndRah605bQZbhB3pH1D7FxWro
bykM/2qrbXA78fN8y9CNy+3kt1GHCjPqpMxhUINvbR/R1RklpXWUQsDpCWq4WRvh
YoFPOJL0twHhifThZjNKkDN+DcD1AqBkOnY8b4a7ZiP3Vwyhl83EXl6/1L/KJ8Pn
urrzRRtwC0pESgao43JSqjInMUotvDJw9FJBNqigqWT4H/2aQk+ZnwOeA9GnQ99t
HQ/Xh2Oi8Qb7aZa28ZdQ3lttOI5bcbTemVsfIQBgdRhEUHQLn4qwXzPfo3bnsfXw
3thdRaTDt7ohX8ZLR/eY9JajqD2poK1Bt+AKS5D8hah0usFGZBAfTzYkg4NPAuoR
T+6tCFUyI7okk8hk5vdmEGLFxLmAIXLX4DzKY768M49d2Re7r+PMZ3iZ+VlzkonO
vVKQmlfcWXZb9z1yogZwLSsswTOGoEiWTNPJcppXrMnAn+XFTziA6g0sPW+F6o5q
HcO0cPw+nK7RkokdWrAz
=eNro
-----END PGP SIGNATURE-----

--nextPart2520623.MFD1FMnYhI--
