Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2HBRzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:55:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:58357 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab2HBRzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:55:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="192565494"
Message-ID: <1343930368.25013.215.camel@sauron.fi.intel.com>
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
Date: Thu, 02 Aug 2012 20:59:28 +0300
In-Reply-To: <20120802194538.26e2ec98@spider.haslach.nod.at>
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ULu0SFlEEDIFxZpPcglP"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ULu0SFlEEDIFxZpPcglP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-02 at 19:45 +0200, Richard Weinberger wrote:
> This should be very easy task.

Right. But unfortunately, I had to spend a lot of time writing lengthy
e-mails. You could hold your horses for a minute, ask specific questions
and find out what was my concern.

> How much PEB should be reserved? 2 x sizeof(fastmap)?=20

Is there any reason why it cannot be the _exact_ maximum number? Not
more and not less.

If I understand correctly, fastmap size is a function of total PEBs
count. You should be able to calculate the maximum size precisely.

--=20
Best Regards,
Artem Bityutskiy

--=-ULu0SFlEEDIFxZpPcglP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQGsAAAAoJECmIfjd9wqK0+swP/3I8WrWJu+FxYmrcZU7j/4S5
f8TyWYtQUyUgnKvE0cIPiknjnfH9/rMN4r2FzntEzr8u+hqDWeIAvGB7CoOQET80
kiQ21uzw5Mzsd9LGrp21+9I+oEdES2wSd1hNVW8THLt5hCPnip61qJjUBYittEjY
x6/FsruOFQW2uQ2g6TXygXF7sUoNPi14kq/4iWfSbUZkl8Toqevb3+RVO/Y/Ow6z
8MC7vmlmxDLbKyU6xD8jXlDuGOHKYuIdr4hWLlF4vZkr0mHdBYyRod4+WlSnYyDV
1qaHGFb0zR6Y5Gf+b1fEKB2pfufBkDermWLafdTgD/dya/wBHp5/ztQEpCazZDpP
/eF0vWI5I9wJPySU+OoajuajbTU4gvByBVSA9b8tHD/F/7yLZ5yLDT6U8t3iYG9I
QM6vpQzWmtaOJtFRAR34S8agjL+kw34crLWiZvtRGR3tV9XHq59lzBmbBOixvWk7
adjIhBGYK4UsSh9/jIRyJaCKjLDdTdq79KcGwjz8XXEt6ti6E6AV/s+2PW5l3kUq
w0RuV+p1kCtMU7mvo9QQzYa0cwFdHiUTy8Cz+tQAqA7XjBeYQK7gmuzah/9F0sGI
W1yi1AmUCcAGSDg6zaGnGYgn7XsF9BE1v9BXuI/cOq+ixwsZehKjSFeXnEl8aCr4
PlLPHJ/Hl+oTx6zlWK0v
=nTos
-----END PGP SIGNATURE-----

--=-ULu0SFlEEDIFxZpPcglP--

