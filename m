Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab2FGDxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 23:53:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57596 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2FGDxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 23:53:35 -0400
Date: Thu, 7 Jun 2012 13:53:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: boot problem with next-20120607
Message-Id: <20120607135320.7a1298385346bc238a0f92b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Jun_2012_13_53_20_+1000_QnczV6cTb70nRkxb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jun_2012_13_53_20_+1000_QnczV6cTb70nRkxb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

My boot of next-20120607 in PowerPC produces lots of these warnings:

BUG: Bad rss-counter state mm:c000000278508000 idx:0 val:-27
BUG: Bad rss-counter state mm:c000000278284000 idx:0 val:-27
BUG: Bad rss-counter state mm:c000000279e13000 idx:0 val:-27
BUG: Bad rss-counter state mm:c000000278285400 idx:0 val:-27

And so on (with different mm, idx and val numbers).  Searching showed me
commit "mm: correctly synchronize rss-counters at exit/exec" which seems
to be there to fix this exact problem?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

P.S. that patch also has conflict markers in the commit message ...

--Signature=_Thu__7_Jun_2012_13_53_20_+1000_QnczV6cTb70nRkxb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP0CWwAAoJEECxmPOUX5FE6VwP/1YegWVnbBdoLeOOomUlvlMB
ZQN1dvuo5PFeSKgT5XcA1hWeVleeTHvG47LzJ49MClrORZlgntHiPkY5hNr2X0Io
BO0bXO7RwOLbDOQzvB4pYVyaAqFyjGKth0bKSwph62YPqPwkbw5NA/g5hVCoLGXw
sNPtouCjnsT1rvm7+uo7CFKNRwg6rroQNJ+i2Dz6D7oxkZ6nUe7ma11gjEOudRL/
E6uToLryBb8wS0AosUWSGkFXeuSVIgDRaOj3njZ78QGNeYUzt32/f/FVw6N4hPjk
OW7x4MfTJZg6EFVN5otj53wq08hmiA/Zy8DGkRNM87wN+iNBgjtVKvNu6uXPeYgu
JwAt1WnoO3vn5S0tndEG248S6aMnJPQmGupZPTo+2uRgwL6VxUkmgUPjDfUPEimn
Aj9gJdShUD1uHD4zcXFV3kY6QLP9V+P1XN5ppCMeVDh0MhnJYnnb1omIbSorrDtJ
83EZvugDhf8OikDuQHXxDeoOtP4SFC26zEYAj4ZViNXWbZtA0If2f1/BvyH8+AuE
9qxirzPFP3NAHZ3HBK5PUKG6bKptlfAbWqAwlKbZzKEwVC/scRvpHwUG9aDKHdLe
OJb4WFmh3TzTkP6Pi0ohm9P08kIh3uZsrGd8EiQHa6nF27P1d16RYLS+2cgiiiVk
Dlm763U8nyDtJHr+nL5k
=PN89
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jun_2012_13_53_20_+1000_QnczV6cTb70nRkxb--
