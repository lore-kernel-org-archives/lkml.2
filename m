Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2HYIuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:50:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab2HYIu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:50:27 -0400
Date: Sat, 25 Aug 2012 10:50:23 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/46] 3.5.3-stable review
Message-ID: <20120825085023.GA1516@fritha.org>
References: <20120820035832.274275502@linuxfoundation.org>
 <20120821170813.GA1561@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20120821170813.GA1561@fancy-poultry.org>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:YGP47jAQ5VWlxI29gUdnKotHBfOwQppw3Wj1upALZBy
 9NKTQgkC2AbwjRShWhS7SqotYTMajaT73b7X9Vq9rSOE3NCmr9
 JvTL+hsb+JFDgEVVw/zC+C/jvyxjpiUMT/Y75DZ892ytGkX00R
 vj8mWjWulnKScXe1qlKdatkNHhnfwkOyeGUH25Ky8zzQzJF6jq
 7Lt710/s3xx0uMjKxlcPHiVDbPnaftIxyB+cHiNSCy1LVAoqDG
 bCyQw7jehkuZUXcQu4wmBsPGKIY0IdYfFUtEi6i+ptjOfNU1GY
 z7xvwtGEk+sfG1S9bS5dK9z476Zsk12XnuaxOYGqZesXDlmTdn
 32GWqRwhQepmHbxvcwu1087FrY2/yTh3GTzDqrsxN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Quoting myself here..

On 21.08.2012, Heinz Diehl wrote: 

> 3.5.3-rc1 hangs my machine on boot (can reboot with CTRL-ALT-DEL). 
> All other kernels are/has been fine, incl. latest 3.5.2 and 3.6-rc1. 

...to let you know that my problem is solved, and it was _not_ kernel
related. I can't tell what it was which blocked a proper boot, but
after reverting some of the patches of the 3.5.3-rc1 upgrade without
success, I updated the whole machine and did a BIOS reset, and the
problem was immediately gone.

So just ignore my previous mail. 3.5.3-rc1 boots fine now.
Sorry for the noise!


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iQGcBAEBAwAGBQJQOJHIAAoJEF+bQu+7rXrnBDAL/1brwjYh+SlG9/boJ1fSnd2j
TjmyL+9P0Vxg7to/XVXEVCB+m6IcZdkim3hSnKdFiZ/MDct+tLDG+frbLXeI7Lri
u7JW19yp/Ct5SvWxqBsFq235svnTE6wBZmNJCGT7nLrIiD6tSA2Ex6dos7DUdNoc
KqMvXbzYDhRwFzjjanQVzZAmYlDw2T9eBSKX+jsh9d9njXAcpHlE+SnG8C2ZesX+
wLWL87bKwVFPmgf4cSl8z5b7kZXknIgf3ptNPm5CaVo7SBkl/Yj5c677zJj3H3Zw
/EwMmQ1fona/KsQVqSO5MVr0SWBBzeDH/UxvdM6PceTczR0K0+lxvUPprz1c1XyV
rpIBuL97GxzQbHH8R8ByxODX0IeYmNVNSlbYOnP0sUOjYNqMz6oMi2u4PjErekGS
1vljex3eBuackr4orb0vvGu10cKxtK0erJ/TQ3r2drU89z9+QiQqMO07XwFrx56l
s6uqPrYCBOEc1UCcobKdbh41FGinz72Hl3RMpHXx5Q==
=jHEP
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
