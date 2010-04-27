Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab0D0ONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:13:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50475 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab0D0OM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:12:57 -0400
Date: Wed, 28 Apr 2010 00:12:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Ball <cjb@laptop.org>
Subject: Re: linux-next: build failure after merge of the final tree (viafb
 tree related)
Message-Id: <20100428001250.fd9f0200.sfr@canb.auug.org.au>
In-Reply-To: <20100427064329.226e623d@bike.lwn.net>
References: <20100427154925.7315ed67.sfr@canb.auug.org.au>
	<20100427064329.226e623d@bike.lwn.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Apr_2010_00_12_50_+1000_DsOCb5+Hy/Noj=Sk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Apr_2010_00_12_50_+1000_DsOCb5+Hy/Noj=Sk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi jon,

On Tue, 27 Apr 2010 06:43:29 -0600 Jonathan Corbet <corbet@lwn.net> wrote:
>
> On Tue, 27 Apr 2010 15:49:25 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/video/via/hw.c:21:22: error: asm/olpc.h: No such file or direct=
ory
>=20
> Interesting...I assume this was a non-x86 build?  Viafb should, I

See above ("powerpc allyesconfig").

> think, always be x86-only...I can put in a fix for that.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Apr_2010_00_12_50_+1000_DsOCb5+Hy/Noj=Sk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvW8OIACgkQjjKRsyhoI8xXQACgnaagzoSIvdwsoq/oNhpi29Lb
M/wAoLk3vsmG3Ljm90txxlL2FghwuLTP
=BrM6
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Apr_2010_00_12_50_+1000_DsOCb5+Hy/Noj=Sk--
