Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0HBIvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:51:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55737 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab0HBIva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:51:30 -0400
Date: Mon, 2 Aug 2010 18:51:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the final tree
Message-Id: <20100802185117.b34f905b.sfr@canb.auug.org.au>
In-Reply-To: <1280736230.1902.56.camel@pasglop>
References: <20100802141035.f84f9132.sfr@canb.auug.org.au>
	<1280736230.1902.56.camel@pasglop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Aug_2010_18_51_17_+1000_TG+8/dQvEj09hw_5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Aug_2010_18_51_17_+1000_TG+8/dQvEj09hw_5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Mon, 02 Aug 2010 18:03:50 +1000 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> Ok, so those are my fault but none are deadly. I'll do a fixup patch on
> top of this.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Aug_2010_18_51_17_+1000_TG+8/dQvEj09hw_5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVocFAAoJEDMEi1NhKgbsajUIAI3KKe0KVRmzkAFLwhqbTIrz
1/CXXDiRy9SqhDb/pINcxAbHurRFZvLAPRvqzCbInhOZ725P6+Hs32DGDBOqG2a6
6ZKTdNbuKcSLT18a2noABUe9vFiYcZPNHbn8FbmnQTMRG1IP1eu97FwLgyee7i4p
S4K3BxmsbF0W30eLlaz8qTZKYiLzcDsDIiVjS+f4PLiVw52aqdSf8Dg+kcOdzU9Y
/mo0rGgbj9eCAmKuOll3UA4WAQYiDXzTTNvw7a2o8uOhwqo3FFqNTkVV17/2AF0I
Mh62qOIfn1N+W9zhWNim2sQaB9z1xZn/S/f9E/INv4ukMMe0FnMeXhAtgYj3PgM=
=FxXB
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Aug_2010_18_51_17_+1000_TG+8/dQvEj09hw_5--
