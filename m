Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1LFAeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:34:05 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48074 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab1LFAeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:34:03 -0500
Date: Tue, 6 Dec 2011 11:33:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Is linux-next.git bisectable?
Message-Id: <20111206113346.57b3efd85780b6ff18076e9c@canb.auug.org.au>
In-Reply-To: <CAB=NE6Uz_gXkY3HGXeW1OnPx84fPVUP=gOJ=2NjBtPZhW=_Bbw@mail.gmail.com>
References: <CAB=NE6Uz_gXkY3HGXeW1OnPx84fPVUP=gOJ=2NjBtPZhW=_Bbw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Dec_2011_11_33_46_+1100__wg1W4Vg+e_za=j2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Dec_2011_11_33_46_+1100__wg1W4Vg+e_za=j2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Mon, 5 Dec 2011 16:29:36 -0800 "Luis R. Rodriguez" <mcgrof@frijolero.org=
> wrote:
>
> is the linux-next.git tree bisectable? I've noticed some trees are
> not. For example wireless-testing.git is bisectable but only between
> master-$(date) tags.

Within any one day, the tree is bisectable, but not really between one
day and another.  The tree is rebuilt starting from Linus' tree each day.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Dec_2011_11_33_46_+1100__wg1W4Vg+e_za=j2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3WLqAAoJEECxmPOUX5FEPdYP/2ZkhYv2aevXBK4CJz77mA4o
TjMqJqtyP8dYfsiLl78BS2rYy1tI4O01aApj2PBTyF4lJyl6ZHJErbG8wnifLsjs
0OfWqsp5QWn0DoCDcjrEJqcH5anpYJY+Pzcw9Jg9s5xpoMc9G9Gutt7btRrvRizm
Br7xzAWYeJHmm08qFcHsWufIDQgCorx2B3k/W8F8T1ePJ5bb/sKmgJyfd+NlfByW
BCKTrBqFAiZJ4xb6rRCf0305Bob8NFeJTsBXdBgfcV+f+0laqkS7uIC6sUqN9B0U
jRiU/4u6OedF3k5kNMbbt01mgKocAgtVA9YHGwGpS7Q3YJ9Pn6E1ykIql9t1MCBT
1gftqtWJsw4E9cABwn1tg2v1gUSD4ENGyw7ShgGIeqYtrFczDY4UnZDsltKJ1J+T
idduIB+TdSdB3+5lkj7euVHPJRVHMh6iwZhznZUPZ1qJb7/LXeUDAqcMm7VZKMHf
oSGBVxGkTijvf6W9ShWgnVGs0a/CsyzJ0DKEmLn4n+bm8tUHngB437EbRHv6h04+
y86Qw6KYrQsZD2iX3WkHJPltJ6a+2YJjSzMswAP6ocmxnxUF01Fl48+KyvumEFET
cO9pmGFvZpJ8pKcgKU2n7qlBQ7yRmcIkMRjpT3JHgVKWP63vXlxlZ5j3EB2y5vPD
AFQx548HjKEbRbDK95Pb
=QJ/f
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Dec_2011_11_33_46_+1100__wg1W4Vg+e_za=j2--
