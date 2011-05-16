Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab1EPEoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 00:44:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43827 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1EPEoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 00:44:08 -0400
Date: Mon, 16 May 2011 14:44:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Turner <mattst88@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Cree <mcree@orcon.net.nz>
Subject: Re: linux-next: manual merge of the namespace tree with Linus' tree
Message-Id: <20110516144405.50ea1b77.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTinvz_jCQhdZP46FY89e8amqvdqaeg@mail.gmail.com>
References: <20110516134733.e448f6fe.sfr@canb.auug.org.au>
	<BANLkTinvz_jCQhdZP46FY89e8amqvdqaeg@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_May_2011_14_44_05_+1000_xKRaCjnP.yl/H3+t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_May_2011_14_44_05_+1000_xKRaCjnP.yl/H3+t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Mon, 16 May 2011 00:00:15 -0400 Matt Turner <mattst88@gmail.com> wrote:
>
> I don't know what the best way to avoid this is. Sometimes (and
> _sometimes_ is the problem) new syscalls are added through another
> tree. Other times, they're added to only x86 and amd64 or something
> and leave us to find out later.
>=20
> So, should all syscall additions go through the respective arch trees,
> or should syscall additions make sure to include all architectures?

Any and all of the above should be fine.  Mostly, the "only add x86"
model is followed and the other arches catch up later.

Conflicts like these are easy to handle and Linus does not mind fixing
them up as they occur, so for really simple syscalls, adding them to all
architectures should be fine.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_May_2011_14_44_05_+1000_xKRaCjnP.yl/H3+t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0KuVAAoJEDMEi1NhKgbsumkH/3V9Cf3cdM8S8rsyWJKmTJS+
yY9zBvmcxDUQOWSEEk2dllb58ukPCMBVw7Y3U9HHqlCJUlqdiDGNKFjU/zHKBYlk
16cAccz3v74Q/Ci70fLhGr0l2mQc112KqwRHrSiAQTyRMfMn0vGcN2k89MhKTkw/
TYy6Vcdbldlu9GaAjAtt0YJnGQgYMWHrE7yQEbtvFBYYndequwdegZQS5fxy2qHg
aDWXbJslBmNwbLydWsXrGlPR6t4wbPwg62GKsC82mGYt6q8lWTmbIR+r038TjFF+
Udbfhq8muO1GiRuIl3e554IM3BqgWa+McO0znX5hL02Kfm7ohiUjmtDj6OaiKbs=
=q/CS
-----END PGP SIGNATURE-----

--Signature=_Mon__16_May_2011_14_44_05_+1000_xKRaCjnP.yl/H3+t--
