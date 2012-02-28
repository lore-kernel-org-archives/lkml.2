Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab2B1FCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:02:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34567 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2B1FCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:02:00 -0500
Date: Tue, 28 Feb 2012 16:01:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
 -v5
Message-Id: <20120228160132.85b1d116f1b025527899ad07@canb.auug.org.au>
In-Reply-To: <20120227140746.61f5fba9.akpm@linux-foundation.org>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
	<4F4BFBEB.8080800@gmail.com>
	<20120227140746.61f5fba9.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Feb_2012_16_01_32_+1100_zItjoIM4Bvyww61B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Feb_2012_16_01_32_+1100_zItjoIM4Bvyww61B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 27 Feb 2012 14:07:46 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> I shall drop
> cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus.patch.

I have dropped that from the akpm tree today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__28_Feb_2012_16_01_32_+1100_zItjoIM4Bvyww61B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTF+sAAoJEECxmPOUX5FEX0UP/j+f7hNR4xxW1VK9ZYegqQtf
7MMzCXBf3xz7nYZd5vuk1qYyvSLEThT2gtoAJganUv75hQOhAqbIa3GRj91MrAvu
68PAhtYBR9Tk2fcqU0e5vW9Gf8bVJXA7s5OjUoGgsm+P99YjYkkRu4YnZ7+ycsIg
fXMnS0SoUgMWNbuUjdbmu08I+4l6C0C/TAqVlN7cNzs4sY2Jc1yoij+96nnTOmhL
fbg/5aWSWDI46T9kOoX7sMTWYBbDp1irGwS+jSKVS0lLzBEQCcCkxkpkLF6thfMa
Z9hlqmC8Izm/4W2SxNn/GxGCCu4yGAcpJrpc8Ts3YFXSJMhSNJFrAKLtBcPMSN3F
CfAPPCityNsxfTNGMEJcxngo4lti6Vp4Wc1lSp/EZaDBQgsJq0f8aR64tP+bM+Ct
wZE1pUp+BNcCgnXI576GPrfwo27Z/HLsj2J23aPndKB+zGR56WYTYWWynz9rtNWu
DzTBybQ8K5PlsJWXxSMBsGLLYELp2tg5sUTBVVHK30Y/kLuyX8c8hjz/xl8VlSw8
sdqbSTtRTmfQlLaiEZy6NyYCBDoYf2qMSjcCfZYwLV+Yv8oMD68aivzm5m8Obroy
CWeXAsbksn4lu8Dezl2kqaNS4zd2ejZQ+B8qs/P3mk4z/uDKRQtG4y5bJJEigoqg
SkhhUgbdTbsuPFUpc76n
=avyu
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Feb_2012_16_01_32_+1100_zItjoIM4Bvyww61B--
