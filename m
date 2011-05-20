Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab1ETCSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:18:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44667 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab1ETCSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:18:08 -0400
Date: Fri, 20 May 2011 12:18:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Hellstrom <daniel@gaisler.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the tip tree with the sparc tree
Message-Id: <20110520121802.f0bf0fea.sfr@canb.auug.org.au>
In-Reply-To: <4DD51D37.3010907@gaisler.com>
References: <20110517131435.aceca54e.sfr@canb.auug.org.au>
	<4DD51D37.3010907@gaisler.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__20_May_2011_12_18_02_+1000_nAKRV0.ug=jjf0er"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_May_2011_12_18_02_+1000_nAKRV0.ug=jjf0er
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, 19 May 2011 15:37:59 +0200 Daniel Hellstrom <daniel@gaisler.com> wr=
ote:
>
> I looked at linux-next and I think the call to the scheduler_ipi is=20
> missing in the resched interrupt routine. I believe that the below patch=
=20
> should be applied ontop of linux-next. Could you include it in the merge=
=20
> or what do you suggest I do?

That patch (if correct) needs to be applied to some tree, linux-next just
takes what it is given.  That patch is really beyond a merge fix as that
code exists on neither tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_May_2011_12_18_02_+1000_nAKRV0.ug=jjf0er
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN1c9aAAoJEDMEi1NhKgbsbckH/0PavaBiWw5MwFtaQVp3ETer
+i7P0XHCU6kSdciKwtLjjyKMaSh7gtU/AIMu630pw/DLXRE+wgEJNN127PNCAk4/
yKP+nCbP4BgAsJ0lDscIY3y1kqZH2jST/4445PGmH/oXtGPyDXRqRyVi7n5rabtT
4Nf7vPO/OAJeOigju+nxrywkYf5sVe9pKXNJEv6RfABkYh1UerzTWXoU9EZoidib
65HxnXP95jAV3ZuqPWEu2MFHsJtQf+O0GLmoDjQC4dG+re6AqeMgwZ5rPEJ7zkpn
kzxUj8wI62MVtAwhrVNOo3j+ShJ6aiZkrePu8LKq0Dh/Ft4ldXmxD1mKGSW3ZYE=
=BwDC
-----END PGP SIGNATURE-----

--Signature=_Fri__20_May_2011_12_18_02_+1000_nAKRV0.ug=jjf0er--
