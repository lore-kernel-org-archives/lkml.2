Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1KPKKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:10:00 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:53690 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446Ab1KPKJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:09:58 -0500
Date: Wed, 16 Nov 2011 12:09:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Valdis.Kletnieks@vt.edu
Cc: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RESEND #3 5/7] arm: omap: smartreflex: clean ups all over
Message-ID: <20111116100950.GA27980@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1321346765-16633-1-git-send-email-balbi@ti.com>
 <1321346765-16633-6-git-send-email-balbi@ti.com>
 <22157.1321403991@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <22157.1321403991@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2011 at 07:39:51PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 15 Nov 2011 10:46:03 +0200, Felipe Balbi said:
>=20
> > -	int				srid;
> > -	int				ip_type;
> > +	struct list_head		node;
> > +	struct platform_device		*pdev;
> > +	struct omap_sr_nvalue_table	*nvalue_table;
> > +	struct voltagedomain		*voltdm;
>=20
> As long as you're de-tabifying the function names that caused the problem=
=2E..
>=20
> >  	int				nvalue_count;
> > -	bool				autocomp_active;
> > -	bool				is_suspended;
>=20
> Why are you leaveing the rest of the struct tabified out to East Podunk?

de-tabifying ? I tabified the entire thing... Everything is aligned.

--=20
balbi

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOw4vuAAoJEIaOsuA1yqREYIUQAIr0n7J+CaGRunbyoEbJqqVM
KolElG9VNy03UDj6fXMjMh2DtbNyye2UNOgnhi+I7JGJXLrEx6HL0lSZnCFXL80d
Mcv4Y63fjBOZ5jNX72yYDBkjXwbWeWLJRo7uKugR2lmksdnaPzAkIZ4WksAtgAU0
ne+iDf/RG/RDPrNqrhVoUx4OnGOl6Kxe6xHdsEJwncLcBWJd1f92k5cpPb2hVEo8
+SZxYgpowTufk8BakktLiuhk13B/PYSut+csBm1GSuXpOY8yPh4KhDc8k9fg+fF5
6hLkeYGi81Ig1CuxXUhOZzaCe+mlevGqz22LA8ntOGf1xT9rIcTVnTVwB0tPtRo/
TuZ0VRhukcRHtrWp1uVpkYh0vlsDKhsaq82Ezth5iZfvURZwWr/Lf/q6rrhh67aw
2FFNu23jmy1fGTPDNVoQM4wm4vDzRNDLLTCBHhJXwCxi4lfjyd1cxpbl0aCVFM51
ndQ9x/3WuATo2IFi5J08hig9o8ciUVlxwZu8TfltchfdZ985mVr9cZkqnNTRR7U5
TB1Ma0yvwtEwk4JFf2szmJRAyXQWFINXbBWL4XCSZ+C+OVirYkTbcA1w9KBrAJkU
XqFRX3OrAmUKveU9LOKrqRo143QmG5EOlGQg8TS14q6H17XSTqDVUbR84WMKtlOQ
pDVCLNuAlX9yjEiigg0s
=R2bw
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
