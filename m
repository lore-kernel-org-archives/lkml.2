Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0HZBFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:05:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40419 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0HZBFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:05:50 -0400
Date: Thu, 26 Aug 2010 11:05:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: rmody@brocade.com, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, huangj@brocade.com,
        James.Bottomley@HansenPartnership.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20100826110542.0269df75.sfr@canb.auug.org.au>
In-Reply-To: <20100825.135957.112609658.davem@davemloft.net>
References: <20100825120927.c469ce20.sfr@canb.auug.org.au>
	<E5313AF6F2BFD14293E5FD0F94750F86A4AE225EE8@HQ1-EXCH01.corp.brocade.com>
	<20100825.003526.35028751.davem@davemloft.net>
	<20100825.135957.112609658.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Aug_2010_11_05_42_+1000_eOiU=i+muyeUFIBP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Aug_2010_11_05_42_+1000_eOiU=i+muyeUFIBP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 25 Aug 2010 13:59:57 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Stephen Rothwell is going to build his -next tree for today any minute
> now and will have to revert your driver from his tree again since a
> fix is not yet in place.

I have done that ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Aug_2010_11_05_42_+1000_eOiU=i+muyeUFIBP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMdb3mAAoJEDMEi1NhKgbsoE8H/01Faz/SEC9cY+IpqolcrAgh
uTKPuiJhfCzAM42xOH+DcQtyfCOOXevy8h7jZLrHQXN/gcVdY045T7UQBx9IQjWQ
vE8ons788rfgW1q/7Ixbo1drlZ1P+xFKVqL30wBwSkXRcutJCo+sjUhZjSWp9WqG
o8Fw+3v+0a4GR1dDlmjaHgCQEa8AGro6pFDwcQYpV/UoenI5MgrD72Kiq++0GwhM
43snUzKBkiKleu4gKzIfTvFFNuHPaUbsqitmlQ5P86v5D5Me1tGPYztJ2CdWYF+G
1nqlp5oFG2ORCf4xohhs2tOHeCiJX5fZm/PVYPhVuiIJhyWqW188pU2umOYt+ko=
=oFU5
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Aug_2010_11_05_42_+1000_eOiU=i+muyeUFIBP--
