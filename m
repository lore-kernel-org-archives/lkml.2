Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2EVWep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:34:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37670 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab2EVWeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:34:44 -0400
Date: Wed, 23 May 2012 08:34:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: bad commit in the cgroup tree
Message-Id: <20120523083437.e4d3f7ed9b11aae3c51dc2ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_08_34_37_+1000_g_TXWXYo88cXB1TG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_08_34_37_+1000_g_TXWXYo88cXB1TG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

The top commit of the cgroup tree (e4968362bd46 "WIP") should not be in
linux-next.  In fact it looks like you committed your quilt series by
accident.

I will use the cgroup tree from next-20120522 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_08_34_37_+1000_g_TXWXYo88cXB1TG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvBR9AAoJEECxmPOUX5FEL4UP/2XCWPFySMBwOk8z9kLd4Nk4
FhaJNkuCvwx3x03dbfFlAMxwr5UTlVeerQa003HuoJ1aqRAtL7xAjTnLoZgDRp12
mwlXNT3aQ/HvKsSfQnnSq0eeLmsAqBOQqXmVJJP3VOAg6S4bthIGA25Zw3q5LD7+
3CYwUmMkPlhNg1sMxnMDwIafJmTI06J/euHjlN3MNvmXaclm5fQvUrJ6I44Jar/I
wdFVLummwE6ctxb7DQfMIZxnH5jOuH4AbY0TWBWy5gKOEWuORCuOaW+R6QXC5KQv
5+ZzWbP76vaI/AahHpvVA4w1nhzjViAezsbcpsMnS5dctA+Rw6OrlMR6S6EdPnF8
YLP3HLT09slSlRxaYJuLtCqHQtREtQHz5MZMglZ2TrR4SNg7KS7Ebc4KS3itfZa7
RS/w8ot71JhpS95s8/c56ZDr4w+1Q12gNj2mysxRiaftb4Qo8jLxkCugvrKB9bPG
+mAEA8/7CuOP+3Sfuiq4sxyOD8fh+hdO1vT6zUc18ky87qZemuBHGFgIJf9COLVJ
x9VVF47V7eXBNMAh3uuUba2w6hf0wPSE3UrhLHUZJkVAUcxmFP3eVbjEvF57gL97
aTQ8sTIUtBiQw/Bh7fqXMTP0XBXPuVEyZvAMvm8al8KGO60+XhMk8wSEPPTQuv0B
ILOTKsQrGvn9JogSkbhu
=XNIj
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_08_34_37_+1000_g_TXWXYo88cXB1TG--
