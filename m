Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1I0XEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:04:14 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:56270 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1I0XEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:04:12 -0400
Date: Wed, 28 Sep 2011 09:03:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: manual merge of the akpm tree with the tree
Message-Id: <20110928090358.10935976cc6c185069082610@canb.auug.org.au>
In-Reply-To: <CAL26m8JbvOi05irJdhtsas2=PWdy4V+hkTYHp029RAvDGnUZgA@mail.gmail.com>
References: <20110927165920.14b00e8595d10135d2a4397a@canb.auug.org.au>
	<CAL26m8JbvOi05irJdhtsas2=PWdy4V+hkTYHp029RAvDGnUZgA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Sep_2011_09_03_58_+1000_k6MZWyNweybQ4krY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Sep_2011_09_03_58_+1000_k6MZWyNweybQ4krY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 27 Sep 2011 09:52:27 -0700 Vaibhav Nagarnaik <vnagarnaik@google.com=
> wrote:
>
> Looks good to me. Do I need to provide Acked-by?

Not to me, that is just a merge fixup patch in linux-next.  It is not
permanent until Andrew or Linus actually take the original patches and
merge them.

But it good to know that it is probablt correct, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Sep_2011_09_03_58_+1000_k6MZWyNweybQ4krY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOglZeAAoJEDMEi1NhKgbsbrQH/0/lLD4am07onUVO9DOKS6D+
IotkQZsLgC7pDhWBnL9MfhpdxvCadE3+/PDdXrFFBOj9DhbmlrsclRgm6k209N4Q
3eMSTGvGrmdgKugoVUh1/X09CQtI4Eap61VhtOO6V8MhXlLxFt1/xNj/ioMGXAay
IETtMu/lhVnPLiH8bSwb4KCE1GMcxyHRaLehglO0obuxf9KlE5OFMPS2FRdry4aN
YiVfXiKOFiXSfAHTvG6jHJb/ZJo/9d8Vn1BWhh1xQ/kwnCxutVWtNEQPNASdvzl6
ovnbSY3y5G18FkOtGMuuttOn4C36ojmdLDSC/aRz2jbrHj0rhEfuKh0YxSul4b0=
=otL6
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Sep_2011_09_03_58_+1000_k6MZWyNweybQ4krY--
