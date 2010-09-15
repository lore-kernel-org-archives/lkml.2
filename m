Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0IOA3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:29:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51300 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0IOA3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:29:40 -0400
Date: Wed, 15 Sep 2010 10:29:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warnings after merge of the final tree (tip
 treee related)
Message-Id: <20100915102930.5e4d59cb.sfr@canb.auug.org.au>
In-Reply-To: <4C8FFE76.8070801@kernel.org>
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>
	<4C8DA517.9000603@kernel.org>
	<20100913143942.7344ada4.sfr@canb.auug.org.au>
	<4C8DDFB4.1020508@kernel.org>
	<20100914145025.977ec2a6.sfr@canb.auug.org.au>
	<4C8FFE76.8070801@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Sep_2010_10_29_30_+1000__P6bUE0_GA63Zk5."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Sep_2010_10_29_30_+1000__P6bUE0_GA63Zk5.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yinghai,

On Tue, 14 Sep 2010 16:00:06 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
>
> Also, we may need to remove all extern and __init and __initdata etc in .=
h files.

Do not remove the "extern" key word.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Sep_2010_10_29_30_+1000__P6bUE0_GA63Zk5.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkBNqAAoJEDMEi1NhKgbsjU8H/jWyF3dOSE6wfc4GmC8PNtzz
BiYYJbqj1Kxmdja37pfcKSA0HK45kVktwSwjMoPi/nuSTuI3V6rzBAChIA+/Lo0I
gGMPJpYu4H4I3vRbSMLcBjQjvliUURag2yNvlDOqFss7ybCjPMBqMxuOXnteibQk
ihc2SvZcUTEJbgP1ulVBjaNBxkjkum153+bL8QYdBIbwCcLWTcQsls00tixkSZYC
QnkQ3cU6Z/p7oCNr3bBW06x1srSdmvFkyFpULpXn+KM4yjnecBZBa0wuR6YOoBgc
9qEZ/equOeukk2BzfS9sjHKy+sIVlQuHfLGiQ6SliLj37gnZaPRt5BHWH5HuPfw=
=lKb4
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Sep_2010_10_29_30_+1000__P6bUE0_GA63Zk5.--
