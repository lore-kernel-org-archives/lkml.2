Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab1CaOLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:11:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60286 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1CaOLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xf83G37YyvQOxoBqlGX/wLgDoGb2bTd4gUTcuE2cTE+o/imm1dHFQJxLYS1oPV1EJE
         Xt6du+2xiMepdkQXoKFQTHUtt5KrtDBAX2b5vMvu1GJ71Tk2GU2OehkT8xH6VW+dwRda
         dLSdOdsGoFYJH+gjNcTsOjo8eP/LvduxL9mGs=
Date: Thu, 31 Mar 2011 17:17:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jffs2: unused variables cleanup in jffs2_lookup and
 jffs2_readdir
Message-ID: <20110331141753.GB4144@swordfish.minsk.epam.com>
References: <20110322121102.GC5086@swordfish.minsk.epam.com>
 <1301579908.2828.83.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <1301579908.2828.83.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (03/31/11 16:58), Artem Bityutskiy wrote:
> On Tue, 2011-03-22 at 14:11 +0200, Sergey Senozhatsky wrote:
> > jffs2: cleanup unused jffs2_sb_info *c variable and JFFS2_SB_INFO call =
=66rom jffs2_lookup=20
> > and jffs2_readdir
> >=20
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>=20
> I amended the commit message and pushed this to l2-mtd-2.6.git, thanks.
>=20

Sorry, next time I'll be more accurate.

Thanks,
	Sergey

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2UjREACgkQfKHnntdSXjTTjQQA5F4KGqLhvbeo2SedRfSIODKD
lmHXeQBvwYvcUvk75RG0MM+KIs8U3qfxxkvBisPnKDD1qAiwqqAclGbxxJBokHEH
Enq4BNlu6X/LnHUgoaVEXLwyWb+wxaRAwU61gDMayD7W8o5lBuCb4UDmCi7aIFgx
TigFCJwX/LDyVAHrjik=
=JZ2r
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
