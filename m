Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2KANRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:17:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56184 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2KANRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:17:42 -0400
Date: Fri, 2 Nov 2012 00:17:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: linux-next: manual merge of the tmem tree with the xen-two tree
Message-Id: <20121102001732.1c02f6a72c9cd2b894d9c6c4@canb.auug.org.au>
In-Reply-To: <20121101130310.GA11029@localhost.localdomain>
References: <20121101144059.a8350c24499f1beffe59a64a@canb.auug.org.au>
	<20121101130310.GA11029@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Nov_2012_00_17_32_+1100_Jh6C.J+sjOJNcgTT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Nov_2012_00_17_32_+1100_Jh6C.J+sjOJNcgTT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Thu, 1 Nov 2012 09:03:10 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracle=
.com> wrote:
>
> I am not really sure how this happen - the 'tmem' tree should not have
> had 7282a68f5aea, and more interestingly, I cannot find it in the
> tmem tree! Either way, let me just reset the #linux-next to v3.7-rc3
> in tmem tree and see if this shows up.

The version of the tmem tree I have has commit a728d5ea1c20 as its head
and has the shortlog below.  I has not changed since Sept 24.

$ git shortlog origin/master..tmem/linux-next=20
Konrad Rzeszutek Wilk (3):
      Merge commit 'v3.6-rc5' into linux-next
      Merge branch 'stable/for-linus-3.7' into linux-next
      Merge commit 'v3.6-rc6' into linux-next

Mukesh Rathor (1):
      PVH: Basic and preparatory changes

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Nov_2012_00_17_32_+1100_Jh6C.J+sjOJNcgTT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQknZsAAoJEECxmPOUX5FEW9wP/2HVsB8udCKh37ePAjQ9DSN5
9YCfmMqvDS+rqn2Z4RWKds8cd0HxcU6P5FlapWYCfHrg1yJjj2Pc05uLqEooCHLj
4dAqNBay8aS4mwG86uZBP8BxEqeUdFq5207TkuHvwEpZXf93il7OSYEeo8eyovSf
xtTcLOYeNFJ8LHSKok5bUqahAFf6ivIh7gRKr2JSGQuLfOgTCbRvny/p29CJpxxp
qweUprMcGjClQNAAXJXM0mEi3lX3wSwZr3/jWH/IJLXg3L5PztVVV8ltJH6yAiYw
p99NaAJocgOgxSiGGpOJz02FO4NAO+veO/6IqAo8nclHhUL9w/tVEWQIqS84ZTU6
Rh52sv5wetE6/LeMKb1k7sJq0F4/tI0MMqGRacSDhCBmGOQ3/uCf6aCt+wScV+VO
0sFEU4G8hRTaZS0KnkEd4Hp0vhYoac0RgzmBigM+4V5hRdysCnsV9y/Ty+zXgNbv
vJA3kU0M+tV8GFGGf238OsMt7/2WvlgCjSnG4GGd02DCP5+GgTWzwGOto6O/quV4
2qlKUss6yYCYGmUJWJh0RCw2yJBqTGAIolcx/XvQhYOUc+MPXZzmiAdWSElE4HYc
8FKX+4/WBfDs/xqff3e/m/xBV3MO+ROndFiIQdGz9OLmfLB5kGu1NI2BHaytaQ9+
RovsgaosawGrsOcKQKAa
=baDI
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Nov_2012_00_17_32_+1100_Jh6C.J+sjOJNcgTT--
