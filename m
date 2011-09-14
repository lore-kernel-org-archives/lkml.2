Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1INAUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 20:20:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38353 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1INAUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 20:20:35 -0400
Date: Wed, 14 Sep 2011 10:20:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Temporary -rcu tree location
Message-Id: <20110914102028.4d7176b0836352b80bfe5693@canb.auug.org.au>
In-Reply-To: <20110913160645.GA6258@linux.vnet.ibm.com>
References: <20110913000107.GA15945@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1109130210090.19238@twin.jikos.cz>
	<20110913002419.GN2362@linux.vnet.ibm.com>
	<alpine.LNX.2.00.1109130242440.13109@pobox.suse.cz>
	<20110913013400.GB2313@linux.vnet.ibm.com>
	<20110913120716.1b893c483ee91d6b7f12a5b4@canb.auug.org.au>
	<20110913040647.GC2313@linux.vnet.ibm.com>
	<20110913160645.GA6258@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Sep_2011_10_20_28_+1000_3gyHt3prNgGNu+iR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Sep_2011_10_20_28_+1000_3gyHt3prNgGNu+iR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 13 Sep 2011 09:06:45 -0700 "Paul E. McKenney" <paulmck@linux.vnet.i=
bm.com> wrote:
>
> OK, I pushed a small update to one of the commits, this time to branch
> rcu/next, again at https://github.com/paulmckrcu/linux.

I have switched to that branch from today.

> I guess that the acid test is the next time I update.  ;-)

Indeed,  It should work, though.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Sep_2011_10_20_28_+1000_3gyHt3prNgGNu+iR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOb/NMAAoJEDMEi1NhKgbs6uQH/2/yJajDcQ1P7kq/GiuJD5Ve
bB8xbrpWXtBQz4iC38nmJ4ye0xMktLWQb2usQeCs87ifSlHpRbEUqFTsugH86cCS
xoPzfxt7tgOFfi2LHy+bQbD6O17jpCVsdOGbT3n+CMl4C2HCwVFwa2MCe2Tm+vZz
NXlWIb4OSdrX6J8yoHVASnDeeitzRWoCORmVWFOA7zyyH4wvXEkkVKBOZgz2Ra4i
uBJl0GN5fa0hR//I6UzFstVh4BrRInQ0WAtRGFs9REle7NRadl3BszVFZ78YPOe8
zify8ofv6qFMSytttlZhSvG2UwLMPGHYYbx0wwXhtWQON6UCSVltwtUuuadWeRE=
=535J
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Sep_2011_10_20_28_+1000_3gyHt3prNgGNu+iR--
