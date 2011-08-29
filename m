Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1H2Fxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:53:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1H2Fxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:53:33 -0400
Date: Mon, 29 Aug 2011 15:53:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.1-rc4
Message-Id: <20110829155328.0375a8d8d3776755c279e5ae@canb.auug.org.au>
In-Reply-To: <CA+55aFwwtfLpmNS+Wm4DXgJsipPS8siF6Dur4rMDum7Zs=KqKw@mail.gmail.com>
References: <CA+55aFwwtfLpmNS+Wm4DXgJsipPS8siF6Dur4rMDum7Zs=KqKw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Aug_2011_15_53_28_+1000_zeuDWzFjWrWr1cnp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Aug_2011_15_53_28_+1000_zeuDWzFjWrWr1cnp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sun, 28 Aug 2011 21:52:43 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
>       All Arch: remove linkage for sys_nfsservctl system call

Unfortunately, this patch (which never made it to linux-next) broke three
architectures :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Aug_2011_15_53_28_+1000_zeuDWzFjWrWr1cnp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOWylYAAoJEDMEi1NhKgbsJO0H/jhHhIHjaEl8XSRRefEaA7MZ
4wUNjiaJOd3Mfus4BI/Sk9R09sc6YWQofoQqz7/ig4+p58ck9GBTWQAf66Nqb+4Y
AZhu4TDjDJ25F9R0PKhqQpz4GogeakYXnKy4XcFnxhOuARierIXDMqcVRiqXhQxe
9Rtwv4A9pg2AGvPMYqYntfgi3P1mRFjj9HIIPPRlBTwUNmPzIhEZ7pdnsWONmorU
OCDM3s+B43OKQTkdj+gt10cTOwBsfcBwWex0Em0pdXbnIQwGldEnuCBQrqaKHbCt
+ExM1bsFhScq6Wf/AXvYtpH4bkDJY6T6XW3tYB2aYZe6USDYtWDKpNVNAttD63Q=
=+kwf
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Aug_2011_15_53_28_+1000_zeuDWzFjWrWr1cnp--
