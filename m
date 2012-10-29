Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab2J2LMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:12:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58311 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580Ab2J2LMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:12:44 -0400
Date: Mon, 29 Oct 2012 13:06:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <alan@linux.intel.com>,
        <arc-linux-dev@synopsys.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] serial/arc-uart: Add new driver
Message-ID: <20121029110650.GA29410@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351252996-28484-1-git-send-email-vgupta@synopsys.com>
 <1351252996-28484-2-git-send-email-vgupta@synopsys.com>
 <20121026121032.GD26342@arwen.pp.htv.fi>
 <508B8536.1080303@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <508B8536.1080303@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 27, 2012 at 12:24:46PM +0530, Vineet Gupta wrote:
> On Friday 26 October 2012 05:40 PM, Felipe Balbi wrote:
> > On Fri, Oct 26, 2012 at 05:33:16PM +0530, Vineet.Gupta1@synopsys.com wr=
ote:
> >> +/*
> >> + * Release the memory region(s) being used by 'port'.
> >> + */
> >> +static void arc_serial_release_port(struct uart_port *port)
> >> +{
> >> +}
> >> +
> >> +/*
> >> + * Request the memory region(s) being used by 'port'.
> >> + */
> >> +static int arc_serial_request_port(struct uart_port *port)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +/*
> >> + * Verify the new serial_struct (for TIOCSSERIAL).
> >> + */
> >> +static int
> >> +arc_serial_verify_port(struct uart_port *port, struct serial_struct *=
ser)
> >> +{
> >> +	return 0;
> >> +}
> > why all these empty functions with wrong comments above them ??
>=20
> Actually serial_core.c invokes the reqest/release callbacks w/o
> verifying for a NULL pointer check. Thus they need to be in there even
> if empty. I've removed the offending comments though !

fair enough ;-)

--=20
balbi

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjmNKAAoJEIaOsuA1yqRE3zwP/R+Jzu4KhdGasFkldkT5b9CQ
mLNwPYMZjFowLRMmt2wOExg3+4xBr3i5yngrrVXzydd8BMIeJnlXMpAKjJSMKr2I
4RY9eFvGCDldJX9seCTRDR3ffHuQau2VlblGqGWo+96/JimBwwccnG9VLQA65u3o
mgWoBWVJS+35o+nYDKichvzzALB8uFr5G6uPnSftWmh8FUwnIs8RjUUbJdev5wUV
2ndksOOi7AqCvcttnWE69C5T760AzpaESB0xD9Oo2L91mt/8hrSrEpWQ33/MKHtY
D9VwcgQlx5X+8q03nEk+60XpBLUWGxmuvUDknVhyFbORMQCMDMUHrJhP5RedeY6a
WCWQSyAOhGMYmcRiXPcaa0h53byoyFhrD2bn3V3Dx3uCcQtM95ZXkV0PMzgpgcAS
9QeN1RhPy7tsefT2dSVsOdfwj0fIVnXSHaQGtcDA6twzt7Z+gFgYSS8QF2v72ton
bBmCjeCd83Iy42J0IFNrQPVUhDK+1LXy0qCl1Sx0U0F/1elYi+DZZI37swbq95Ek
tQTmxq67r7g5Kfr6GeSeKtu0stMP3H8ARKxmFI0wLZ4z/OBjAh2ayEkXtoS/iKQ2
8zVXljaHIRn1crFxUo2lxL4IkkoJsQc91lZ9LIQejN/UrS0w/TX5C6NgF1BGWBm8
QS3aQuqdCiex90ji1VDB
=LO9b
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
