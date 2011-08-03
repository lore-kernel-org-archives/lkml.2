Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1HCNax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:30:53 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:46279 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab1HCNat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:30:49 -0400
Date: Wed, 3 Aug 2011 16:30:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per =?iso-8859-1?Q?F=F6rlin?= <per.forlin@stericsson.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: ux500: replace missing DBG with dev_dbg
Message-ID: <20110803133044.GN11080@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312374137-10629-1-git-send-email-per.forlin@stericsson.com>
 <20110803131749.GL11080@legolas.emea.dhcp.ti.com>
 <4E394CC0.7050208@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOh8F6DNH/RZBSFD"
Content-Disposition: inline
In-Reply-To: <4E394CC0.7050208@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOh8F6DNH/RZBSFD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 03, 2011 at 03:27:28PM +0200, Per F=F6rlin wrote:
> On 08/03/2011 03:17 PM, Felipe Balbi wrote:
> > On Wed, Aug 03, 2011 at 02:22:17PM +0200, Per Forlin wrote:
> >> From: Per Forlin <per.forlin@linaro.org>
> >>
> >> ux500_dma.c fail to compile becase DBG has been removed from musb_debu=
g.
> >> Use dev_dbg for all prints.
> >>
> >> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> >> Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>
> >=20
> > applied, thanks. Let me know if this should go to stable and I can make
> > sure of adding stable to the Cc list.
> >=20
> I checked v3.0, and both ux500_dma and cppi_dma use DBG. These two
> files wont build in v3.0. Please CC stable.

ok, will do.

> I am about to send patch to fix cppi_dma as well. Should I CC stable
> when I post it?

yes :-)

--=20
balbi

--hOh8F6DNH/RZBSFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOU2EAAoJEAv8Txj19kN1ctAH/iznL/vNapycHpQLyJ1RlVxn
G2iX9g8/xcSGdth0thSAfHSKQVSpSv50hgysNMCQhyw2LwsUL43QKD4vmFcK7wvb
Of9xCs6wYVMEFooz47+Jvnibd2sL9ivcPi+gMEQwa7QsX9ij+PNETtnuy6AhhNc4
m0NtSAyJdlus9mXvhBHQ/EBDS/QgA0shbeRo54eTYQpDxP553TqIvyL9KpXRFYCK
Fr7XsRqKNJzlkco6dZ8riUsfWmBqly18NQWOszInRXG9mDHp9cvFSDCTuwXeJfky
pW21siRV+cmG72ZljIhV0YHQj94OlwElKcUWXwP7LNTHG5Vlnr5Bb6M+2bHboUc=
=IUBy
-----END PGP SIGNATURE-----

--hOh8F6DNH/RZBSFD--
