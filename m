Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1EQHV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:21:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57229 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1EQHV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:21:26 -0400
Date: Tue, 17 May 2011 17:21:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: manual merge of the tip tree with the wireless tree
Message-Id: <20110517172103.a196fbe1.sfr@canb.auug.org.au>
In-Reply-To: <20110517070558.GP2573@linux.vnet.ibm.com>
References: <20110517131417.731cf095.sfr@canb.auug.org.au>
	<20110517070558.GP2573@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_May_2011_17_21_03_+1000_442m0CjmXmehh+TK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_May_2011_17_21_03_+1000_442m0CjmXmehh+TK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 17 May 2011 00:05:58 -0700 "Paul E. McKenney" <paulmck@linux.vnet.i=
bm.com> wrote:
>
> One of these is mine in -tip (0744371aeb).  Please let me know what
> I should be doing about it.

In this case, I would say absolutely nothing (assuming I did the
resolution correctly) :-)  If I can figure it out, Linus can as well and
will do so when these trees hit his in a week or so.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_May_2011_17_21_03_+1000_442m0CjmXmehh+TK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0iHfAAoJEDMEi1NhKgbss6cH/R8hBInCDsaouivVuIVrkj9T
KTyMsOzKbr7+ZfXQUJGBsPj7L3HmN2TEuEl3P3ueGpftMBvIhNWbF1eBo6/2MzSi
lz3G1T5mwyL0+TJyAwHV4GEpLbpYhe8a7FZKQ38W0+bNjWcFdcONiApJQUKv0qMV
51oS1WGsWVHyf18gVQ/Z3xoEb80WdaRmaGRU/2r8itqiR78g08uVz9xpSEQx9nMO
xBbm2gooQP5DPVlkpLwiJsIadWzTjHN1PJX3CvBcJODxhF0djH5mnbQ3eS/exBAO
y1m+YCXjvjka3PAhCVNUnMOzHNSIiplFFyQDt4QSsKPWA2tM+nHv7uX7iI66tOo=
=bwtj
-----END PGP SIGNATURE-----

--Signature=_Tue__17_May_2011_17_21_03_+1000_442m0CjmXmehh+TK--
