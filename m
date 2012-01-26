Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2AZWgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:36:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53502 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2AZWgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:36:43 -0500
Date: Fri, 27 Jan 2012 09:36:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: merge of the arm tree into the at91 tree
Message-Id: <20120127093619.f2c90c6aa8b542134a157956@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Jan_2012_09_36_19_+1100_sjeqKmYJCys86mlx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jan_2012_09_36_19_+1100_sjeqKmYJCys86mlx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I noticed that the for-next branch of the arm tree has been merged into
the at91 tree.  My understanding (and Russell, please correct me if I am
wrong) is that the for-next branch is *not* stable and may be rebased.
This will cause all sorts of problems in linux-next in the future (and
also when Russell or the arm=3Dsoc guys merge the at91 tree into theirs).

In fact, I am going to have problems today as Russell has already rebase
his for-next branch.  :-(

I assume that the merge was done to fix some conflicts or pick up some
functionality that is in Russell's tree.  This should be done by merging
topic branch(es) of that tree that Russell has explicitly said are stable.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Jan_2012_09_36_19_+1100_sjeqKmYJCys86mlx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPIdVjAAoJEECxmPOUX5FEx6kP/2eOPQsJ48Pr47Yc7OiJgwDk
6FJOjytBwj5Zd6CV4mmnpfqW2T46p1wIePYo0aTwn5ToHL+G07yyUoxMnJ0vTqao
G0eXZGTuDGmXUP3hbydGHIOtz7GaQpXGlmGuis3NUAzRuq3QQhkKx8TqriV3fUKH
9V4iOEAEbih7I3owFOLOoRPXLyKP7ff1VkWlze9F6DK/nuwuNO40xHc9tzm8qAoI
wGMUz22QWNNoHnGQvipjX4n0rRzOPqEg/zV1yMaZqS557w1zqFT0QyYoBfv3w6+v
z2PwaE9TTzMa8nZCEazXFOlpPaLsPTrq6jtsEui++QZG7ySOnxE+drhTxWGHO1TL
frTPSRfnmNn640MmCT9nzT16oNu8dG6KGjXjzRL33CKOU33EpEEADjeSjI/WQ1OU
5mUcGRPK+ufiBfNQWSg9FRxbCR1/zRNZeI/zW7mhnJe9JiNmS22NYMrji/aihmEz
fSlYQnQT+XlE+XHRJ4f4go8JrIHJAcsUnJ2sbs5SFWqoHVjkc/IiwIjk8DHKGm8R
XuecBYotB0IYLE3XDylIiAWS5fQXMPS4lAxRDl6yjub6Mfs3ivGmJ4bybtcQfA9f
NV1Ulesf3+Vza2Nm7+SAI1/E/5Q5510paWHP7YH6PH9u+R94T5K3pJj0RxrmMXu8
zVRXYvfZure4QhmwCzxd
=w6DT
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jan_2012_09_36_19_+1100_sjeqKmYJCys86mlx--
