Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab2EaI2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:28:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45417 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab2EaI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:27:58 -0400
Date: Thu, 31 May 2012 18:27:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120531182754.5c2affb31490bb3c5afced8b@canb.auug.org.au>
In-Reply-To: <20120531182451.ad63c2bf993ce2f5400896a0@canb.auug.org.au>
References: <20120531141329.6f82889bcfaa30ca83a30937@canb.auug.org.au>
	<20120531072505.GA1371@cmpxchg.org>
	<20120531182451.ad63c2bf993ce2f5400896a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_18_27_54_+1000_tz3+E4vBIg54bTCC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_18_27_54_+1000_tz3+E4vBIg54bTCC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 31 May 2012 18:24:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> > On Thu, May 31, 2012 at 02:13:29PM +1000, Stephen Rothwell wrote:
> > >=20
> > > Today's linux-next merge of the akpm tree got a conflict in
> > > mm/memcontrol.c between commit 78ccf5b5ab83 ("mm: memcg: print statis=
tics
> > > directly to seq_file") and others from Linus' tree and commit "memcg:=
 add
> > > mlock statistic in memory.stat" from the akpm tree.
> > >=20
> > > I just dropped the akpm patch for now.

...

> I will remove that patch tomorrow in any case.

I should actually read my email - I already did remove it. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_May_2012_18_27_54_+1000_tz3+E4vBIg54bTCC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxyuKAAoJEECxmPOUX5FEllAP/3fMaqOoOCKWYhA0AjVDpuah
I4y9TsOV3Vb2Bt3IB7n+TnHmtw6lOtkk0ZPFOo6+AdcfcoIqDG46EnR77Mq8fFx8
rdGWHDz2YSYlI9BR4Comkrg2+8PoUTL0CAYAqIwR9VpLwTOn4w55kuTA6giR5ioE
QkxHi7p/WAw4lFtg1Z4LS+2ifJC6CKL9xKiUlrYTwjUSuxeFll/JJKd6orDpNldM
/dgbrJ2dV8Kj8+JUl1xNR8d6MLiv5QMvI7uya+CLw6Fhd4xj7QlOdocdPO8h4+Eg
4Hq5MiIZq2L3cP2i1NYS7Am7hPwUD0OJZOUjtAvNTu82RBfj/sCy+zObK3zaOR8u
9Ik9na/GKjhtOeizvKsGnBfBUhQkY9ivUsHPIctIBRnK4nEU+o7u62SIQk4nPxse
cWtgxiDaipsNghLsN1YLB0IiQqWpAJKMvm27x2sTUxojSzwDLLTwHKxYvvrh6rrB
+UNScsWNrjzdrxr1sGJVzjswy8Vl+ZHHPpwDmUBV7ziJKfBEHB//ANjQJceeiGwx
ktfAuyL7Y89WOGiPRRpWX0EGGYK0ZGV74CPRHTzD/OamGQZwIUYI0Y0XOoCAqaHO
5Ks7etUP84PD3vH9z7msYCmhhf9r7qTNkR/5pasfGEbqk+fzownkAu9UKQkPpcW/
sJnJnihE1nX45pwxX7+L
=6my/
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_18_27_54_+1000_tz3+E4vBIg54bTCC--
