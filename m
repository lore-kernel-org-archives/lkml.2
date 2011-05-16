Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1EPOwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:52:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56642 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab1EPOwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:52:10 -0400
Date: Tue, 17 May 2011 00:52:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: manual merge of the security-testing tree with
 Linus' tree
Message-Id: <20110517005206.4158b74a.sfr@canb.auug.org.au>
In-Reply-To: <20110516141359.GA9430@mail.hallyn.com>
References: <20110516130209.0477a9e7.sfr@canb.auug.org.au>
	<20110516141359.GA9430@mail.hallyn.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_May_2011_00_52_06_+1000_5nUaRqnkW.53Fz7B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_May_2011_00_52_06_+1000_5nUaRqnkW.53Fz7B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Serge,

On Mon, 16 May 2011 09:13:59 -0500 Serge Hallyn <serge.hallyn@canonical.com=
> wrote:
>
> looking at commit ffa8e59df047, it also adds
>=20
> +extern const kernel_cap_t __cap_full_set;
>=20
> under __cap_empty_set.  My trees are a bit screwed up so I'm not sure if
> that gets later removed, but I just wanted to make sure you didn't
> accidentally drop that.

Yeah, it got removed in the next commit (5163b583a036  "capabilities:
delete unused cap_set_full"), sorry for not mentioning that.

> Otherwise looks good,

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_May_2011_00_52_06_+1000_5nUaRqnkW.53Fz7B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0ToWAAoJEDMEi1NhKgbs1DcH/iukLBr19uJfocI1II1aDGgA
nQcckLX2Iwpi/9nleBz3la6epeYozkOYkSkol1GNMVuyi/el7sMzUc0PEmxI9eJE
XYt+43HNH8fYsiJI8a5BSy2TKVarkHi5w9++dW2AP4OzQ+ApdQ8JUWhQp6/Jw26M
P+nVGcOtR/pFzL8rHD+uUcrmBsa3yrjpMSf4SlTLa8k1QOhvIOcPdIKyuW35PLKV
9ls4QaqraVSmdkkajHzRHRc+mrFrjnmoBLeTaNsA6a5+/+Kxj0agfCHflozbZBfe
TbN/QeG4W3VAQvS6IYTFfMyDe+vtljf5iZPVCzyWGaqsVzdvEOGZPUOhg84NPRU=
=uO4y
-----END PGP SIGNATURE-----

--Signature=_Tue__17_May_2011_00_52_06_+1000_5nUaRqnkW.53Fz7B--
