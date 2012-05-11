Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083Ab2EKOKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:10:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37274 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab2EKOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:10:12 -0400
Date: Fri, 11 May 2012 15:10:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>,
        gg@slimlogic.co.uk, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regmap: Add support for register paging
Message-ID: <20120511141010.GE3960@opensource.wolfsonmicro.com>
References: <1336733724.5950.3.camel@sw-eng-lt-dc-vm2>
 <20120511122719.GA3960@opensource.wolfsonmicro.com>
 <CAEqHmAtm4-TkdmLSc-HUPMo_Fyw4WK+d6Xj=X9z1m4kK1A0oJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Content-Disposition: inline
In-Reply-To: <CAEqHmAtm4-TkdmLSc-HUPMo_Fyw4WK+d6Xj=X9z1m4kK1A0oJw@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 11, 2012 at 03:55:54PM +0200, dd diasemi wrote:
> On Fri, May 11, 2012 at 1:27 PM, Mark Brown

> > right now the diff is pretty hard to read so I may have missed some
> > issues and I'm also reluctant to add any additional combinations of
> > build options that aren't actually needed.

> I did some rearrangement in the code, like splitting functions into
> halves, so it is hard to read it from the patch. However, I have not
> changed present functionality and if paging is not initialised, regmap
> behaves the same way as before.

Ah, if you're going to do this sort of thing the best way to do it is to
rearrange the code first as one patch then add a second patch adding the
new functionality.  That way the code motion isn't mixed up with the new
code which makes review easier.

> I will prepare patch without compilation flag, as it is not so important.

Thanks.

> > One other fun thing which just occurred to me is that I've got a bunch
> > of chips which have several independantly paged regions. =A0I'm not sure
> > that's really worth handling here, though.

> I have more advanced solution, which actually makes register mapping
> split into virtual address ranges. This may solve many problems,
> including giving capability to support several indirect register
> ranges at once.
> Let me know, what you think about this API?

I think that sounds roughly like what I was thinking of so it's probably
sensible but obviously it'll depend on the implementation.

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrR1OAAoJEBus8iNuMP3dofEP/2A0P4KFIIheUhAGmyoR5B/n
VhxF5ZahEBILtYfZEwmdcvahUsaswnVZ+bCKQrvLnMTgoR9mOYnDkzX/gKDLTxTK
8+MAkn15sdSb8lWwiGA0C51szv3zpPaY4EVf92PVb7Ch1eKsrvtEWJD1OkG6JXF5
ikKdqvFi1SkyQkDwCTnVJVvALJD1Ez5jIWiKI/1kv+/eHM85/7GngQfxBFyrObph
PSvqlTqIVah2BAXktU2kqM7FpC/N63Qp/bDSrT7KYvQNF/Ae8YOjsqW2PJUv/cV/
u2Mu5LhClCebqQja6yhXifGn+mj7u2Gp61fuZePAtZ+SfcVNF23C/Q2UqNKjw+4y
7uUIQvDxKhVsfDDaLvv8Bo+cgNB4Wu8qmmCueuUO0EbZUonc+pJ8JrP+2Xzq0syc
7qEAaafVS9lFttCNum5ce3OM15ZvtlNkStxno5JDBOdk21kAYJAKNNMfUZ54IYSR
uXWpeiMhvrs32JcNlrzjxu70Rxx8NGQuelKqwxwNuZQFUkOwWNaqzPQnKu6g7H1t
X6bUOza5/HN5D9uE6/g2S1iB7c6vZjzfENPR57s4fTfsp26iXdhUQWm8k30ZciRB
itrKzlZyWpYlJSNo4A9mbWFyVB0BtANaYbAvRM7WGU4pwHECAh2BujHQwaQ+iSvS
I+xZSfSYF0/aKwKuSON7
=nUdS
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
