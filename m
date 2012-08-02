Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2HBSL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:11:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:47961 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab2HBSLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:11:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="180847610"
Message-ID: <1343931352.25013.222.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: Tim Bird <tim.bird@am.sony.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "Heinz.Egger@linutronix.de" <Heinz.Egger@linutronix.de>,
        "thomas.wucher@linutronix.de" <thomas.wucher@linutronix.de>,
        "shmulik.ladkani@gmail.com" <shmulik.ladkani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Marius.Mazarel@ugal.ro" <Marius.Mazarel@ugal.ro>,
        "nyoushchenko@mvista.com" <nyoushchenko@mvista.com>
Date: Thu, 02 Aug 2012 21:15:52 +0300
In-Reply-To: <20120802200326.37a2d827@spider.haslach.nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	 <1343916747.25013.112.camel@sauron.fi.intel.com>
	 <20120802161512.5ac7a303@spider.haslach.nod.at>
	 <1343917741.25013.114.camel@sauron.fi.intel.com>
	 <20120802165132.1bf1e5d7@spider.haslach.nod.at>
	 <1343924267.25013.156.camel@sauron.fi.intel.com>
	 <20120802183210.7076aa48@spider.haslach.nod.at>
	 <1343925930.25013.163.camel@sauron.fi.intel.com>
	 <501AB2C8.9010805@am.sony.com>
	 <1343929200.25013.197.camel@sauron.fi.intel.com>
	 <20120802194538.26e2ec98@spider.haslach.nod.at>
	 <1343930368.25013.215.camel@sauron.fi.intel.com>
	 <20120802200326.37a2d827@spider.haslach.nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-TC0JOgDE6Z0o/7OZKPhm"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TC0JOgDE6Z0o/7OZKPhm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-02 at 20:03 +0200, Richard Weinberger wrote:
> > If I understand correctly, fastmap size is a function of total PEBs
> > count. You should be able to calculate the maximum size precisely.
>=20
> It does.
> I was thinking of 2 x sizeof(fastmap) to have reserved PEBs for the
> currently used fastmap and PEBs for the new to be installed fastmap.

Up to you. If you are fine with the overhead, you can go for 2x, I do
not have objections. But would be nice to include the overhead numbers
when you submit the patches. Also print on initialization.

--=20
Best Regards,
Artem Bityutskiy

--=-TC0JOgDE6Z0o/7OZKPhm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQGsPYAAoJECmIfjd9wqK0HNUP/1wRCUK3e7KFh4RLmVDPrekD
GlsNwBXOYr2UwLGBv9ZDClv9sfJiiNC5aJTLl4dfIC7t9h7YCHvHQKWXydPw49aK
FuOMVrPvLpSVToZOM7kVLAxzOtHAUle6K1ekl+ZljOYWgO9Y1U5Pf5Dcn2qGYyec
VuGaiVrrGMyUvwJfZP6Onf5bzE0oJ2d0FvW5Zfkn8gmkkuVjUk22DV53W5ED1TyP
JFJtMrAgKbZzlCSLOD4xxS1Sl18wJQ0A1nbnatX6B2ERx0GzTZ62ogIv+aV6Bacb
Ba/hWnf4NJuZjnFMxLkrzeeDHc9AUGxTED9XqNHZ4OR0KfVgFlYhv06pJEU2BeEo
oO8JA84qyOLO8hwPg/4HjP5AQxQDq1Tk0r9HpvC/K2fXlgAhxp73GV0JENQjfFRt
bIpWkIT0resmsaAin7hEi6kN4VLaIvEOuh4AHwi/Y8s4oDtNTHVgK4f3DfIgMgka
a4vOXCABC3eUOAoPyxnI6IYw5NeiWnnyvyHmOyjlwqBH5WCxjFyCD0M1pL8ykqfM
FZ05C52pmnbH9Gf68OISRi7nFUkgxxk3/+1G9xIBgcOcnTiMq7S5k3JKADH/UZ1+
7tm4ggxH6Louva4O8BooMr5t1dJquVufB7Htmd1LVM82qTRWkvgY+mu5XDZDM3iS
AL+U6rHFWtGrgN66vD6l
=OPGd
-----END PGP SIGNATURE-----

--=-TC0JOgDE6Z0o/7OZKPhm--

