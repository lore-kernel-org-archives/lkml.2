Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab1KHPkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:40:11 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:49404 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab1KHPkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:40:09 -0500
Date: Tue, 8 Nov 2011 17:40:05 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "'balbi@ti.com'" <balbi@ti.com>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'khali@linux-fr.org'" <khali@linux-fr.org>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'rmallon@gmail.com'" <rmallon@gmail.com>
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111108154004.GK20728@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320753142.git.n.voss@weinmann.de>
 <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
 <20111108144115.GH20728@legolas.emea.dhcp.ti.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B38B899@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cN0A5YokcrYPGsSB"
Content-Disposition: inline
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B38B899@wm021.weinmann.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cN0A5YokcrYPGsSB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2011 at 04:35:21PM +0100, Voss, Nikolaus wrote:
> Hi,
>=20
> > > +#include <mach/at91_twi.h>
> > > +#include <mach/board.h>
> > > +#include <mach/cpu.h>
> >=20
> > avoid including <mach/*> on drivers.
>=20
> Should I move at91_twi.h to include/linux (omap does it like this,
> other use the mach-include)?

maybe, is at91_twi.h some sort of platform_data ? there's
<linux/platform_data/...> for that.

> > > +	if (irqstatus & AT91_TWI_TXCOMP) {
> > > +		at91_disable_twi_interrupts(dev);
> > > +		dev->transfer_status =3D status;
> > > +		complete(&dev->cmd_complete);
> > > +	}
> > > +	else if (irqstatus & AT91_TWI_RXRDY) {
> > > +		at91_twi_read_next_byte(dev);
> > > +	}
> > > +	else if (irqstatus & AT91_TWI_TXRDY) {
> > > +		at91_twi_write_next_byte(dev);
> > > +	}
> > > +	else {
> > > +		return IRQ_NONE;
> >=20
> > coding style is wrong. Also, are those IRQ events really mutually exclu=
sive ??
>=20
> These are indeed mutually exclusive (semantically).

so you couldn't have AT91_TWI_TXCOMP and AT91_TWI_RXRDY set when you
read irqstatus ?

--=20
balbi

--cN0A5YokcrYPGsSB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuU1UAAoJEIaOsuA1yqRE2r8P/AwmLrcJP264ulVpxtuv8lNc
yt6fQoS2boPLhRbin8z4gqSHCJKdmglT2BBMp5rkGDIVN2bE2kmNXGRFdg7o0jAK
i7PVsHl2xZVhlWA5CrjZBFZqsH26EK7QrD9TsHXN9FiEGxKq+2oUYxA2Z/R5x+Ws
809VN9lU9Lu4jfBWfjpNknMgTV1DSvSYSq9Scso+4q26cjmZl1WgL+FQ9tSF3Qe+
j7+YDDsLcnAHZuekGc3CbaEQmp5iVJ9nSMmhBADUey2nYXSbi1+qcIAuEYSZgJ7d
pGWkXxW9/fEPcApnMp68puM+X0F9aJjfSj9SLKbw4Pw4yHzHgqSpJrkfgj44KCbr
LH2mtN+WG3P833LUwqs2sOjv/P6I8F7xK5eey+DOHDhiKMAfSsysnq9iB2i0fw5c
VjC+iw/25wMTMQWaDpA0Vad6Ew0v1/0WxvQ6o9W06V+V/GgYRx4J1qaVCYWJjKSs
w+QT877HgXgg4UPtSWjJ0lXFuBQB+SQaRTE9sXyJ5IgUzStqOfE7W6WY0ntzzqWy
RZm43IyCc3VJ9CcJJar6LOOWvvxxA3puvLJknEOyeb1Dgn72bjH3235UDR/Rr71F
6P1/rNsvMqJEtpLMqIKfl7KwTTW7vexwgl/cVg18YgFV9wv7ZCHv1udbZ7aukBB4
5FIB6IW+8S852r4tToD2
=J/Z9
-----END PGP SIGNATURE-----

--cN0A5YokcrYPGsSB--
