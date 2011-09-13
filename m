Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1IMBVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:21:39 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42195 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab1IMBVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:21:37 -0400
Date: Tue, 13 Sep 2011 11:21:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Temporary -rcu tree location
Message-Id: <20110913112127.cd62b006c302a575ceae4dee@canb.auug.org.au>
In-Reply-To: <20110913000107.GA15945@linux.vnet.ibm.com>
References: <20110913000107.GA15945@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Sep_2011_11_21_27_+1000_AqeOEFi3p26ijENb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Sep_2011_11_21_27_+1000_AqeOEFi3p26ijENb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Mon, 12 Sep 2011 17:01:07 -0700 "Paul E. McKenney" <paulmck@linux.vnet.i=
bm.com> wrote:
>
> Could you please make the -next tree pull from branch next.2011.09.12a
> of https://github.com/paulmckrcu/linux while kernel.org is down?

I have swiched to that now (actually git://github.com/paulmckrcu/linux).
Just a couple of minor changes and some new commits, right?  Hash of the
branch top commit is f88a19a.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Sep_2011_11_21_27_+1000_AqeOEFi3p26ijENb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJObrAXAAoJEDMEi1NhKgbsi7UH/jRMBXgf0nnDdE6v0iq6e8v2
i3GRemVYxKQ4hKYoSbLFF0l35rSh8Uow99q2oLQDXdI/+61cBUKebc5GVhgQDoxp
tUqiQfqybJQwycPwXbIoBe/haUiqPbuNINQDCjTOcI1j3ITtRXh2+oett4p1nd+t
IPFCwk/NVqT1eLobYynFRQ6AqFZqGOq1772bdGBrY/0eb0x2sJ2vv5A+qgPwsbWR
HffvgBuIcA9zEoDVDeaoU7ZdbQcTOwdL1EorvVVQOPRXsZwdpXIr1OP+WybJmHeb
HpPeHjUsoieXEfYeme22U04fEtp1WJVZtmZ1lKanTFAjJJAP4Y6ceFeOUvqPCa4=
=T5RF
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Sep_2011_11_21_27_+1000_AqeOEFi3p26ijENb--
