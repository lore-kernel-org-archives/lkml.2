Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1G0TPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:15:39 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:53989 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab1G0TPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:15:36 -0400
Date: Wed, 27 Jul 2011 22:15:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC][PATCH] musb: Avoid musb_gadget_pullup "Unhandled fault"
 oops on omap4
Message-ID: <20110727191531.GB7898@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1311206974.2945.198.camel@work-vm>
 <1311608634.2945.265.camel@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <1311608634.2945.265.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 25, 2011 at 08:43:54AM -0700, john stultz wrote:
> On Wed, 2011-07-20 at 17:09 -0700, John Stultz wrote:
> > I've recently run across an "Unhandled fault: imprecise external abort"
> > oops that is caused when a driver called usb_gadget_connect() when there
> > was no cable plugged into the musb gadget port.
>=20
> Felipe: Ping? Any thoughts on this patch?

I'll be queueing this one. Can you resend with:

Cc: stable@kernel.org

--=20
balbi

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMGPTAAoJEAv8Txj19kN1ofYH/1TGZvC8EV7yI815n2R2k8DP
7mDcbz5eIWfTikijpf29k1Id87JwiN5tR8lnmMu+fsce92oPgm1CI/Rb91Znazav
JuUWNDKw6+AaBSmfFsnABaqEBVbLHjafoa0OYAwi7h+dht79NqhV87O6QRhAGr+F
o0ZN3XS87kkqmxZ5B/CnT1Y2QAa92x1F+P1pBxZ5WPAN0H8tnKL89V3WFtvd5nC4
eL/Q2/qz7CVubvR3G+LD+QW3xwi5mqnPobNC4a05mZ75JpLmM1HNwf+MhkHo4gYK
y6P4uRdsNXH5K4DFgO1p6h0Xa6KpHF2FOtCpVX/yhpfeu+n2ZhA6uBcmdQz0gzc=
=nMDW
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
