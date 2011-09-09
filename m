Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1IIGqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:46:07 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57848 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1IIGqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:46:01 -0400
Date: Fri, 9 Sep 2011 16:45:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dedekind1@gmail.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nico Erfurth <ne@erfurth.eu>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the at91 tree
Message-Id: <20110909164539.bae897109d3de0e67f0db69a@canb.auug.org.au>
In-Reply-To: <1315550734.7905.14.camel@sauron>
References: <20110909132920.3696fbb6c1b90cded9727d30@canb.auug.org.au>
	<1315550734.7905.14.camel@sauron>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Sep_2011_16_45_39_+1000_uVxBOIFzIxVPP9Lh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Sep_2011_16_45_39_+1000_uVxBOIFzIxVPP9Lh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Fri, 09 Sep 2011 09:45:28 +0300 Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
>
> OK, thanks, I guess you'll carry this modification so far, we'll need to
> take care of the conflict when merging.

Yep, no worries.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Sep_2011_16_45_39_+1000_uVxBOIFzIxVPP9Lh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOabYTAAoJEDMEi1NhKgbswdIH/24lau92ady72wzxP9epgDPB
UKghbf8+vVPYkxBeERn9NuRg+Ez6iNjgrPSRjfrKkz24cj6VSfpYeOoBY4usU21C
XOVlWqun22eT/33TKxtk7T9q/d8auiT0M6aiIndML8TNSy9TIt/btPdiJtMN3mKf
desUYOItMFewWWIeZh0HMPqUlpke3QmTzlTvXXntU6wPqDRVRVgEdJezhVPSAosp
bDkkGzBJ8pFCWG/ni1pLq8783XmcILnPtLB+LSQrInMpJMcTXqAQ8xJ17YzdxX5c
SfQUqwZfDmkKjHnJiAVGKjiyXwus146OBwi8ZY6D1of+0L14Po6WgiQjh90G1J4=
=Sn3K
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Sep_2011_16_45_39_+1000_uVxBOIFzIxVPP9Lh--
