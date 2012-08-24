Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2HXL21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:28:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49469 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2HXL2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:28:25 -0400
Message-ID: <50376550.4020501@pengutronix.de>
Date: Fri, 24 Aug 2012 13:28:16 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
References: <50191EA5.1040303@pengutronix.de> <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com> <20120824051016.GB1718@vandijck-laurijssen.be>
In-Reply-To: <20120824051016.GB1718@vandijck-laurijssen.be>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig00580F959376127700432EB7"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig00580F959376127700432EB7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/24/2012 07:10 AM, Kurt Van Dijck wrote:
> Hello,
>=20
> I find the CAN led triggers an interesting thing.
>=20
> And then, this scenario fell crossed my mind:
> Imagine I do:
> [insert CAN device: can0]
> $ ip link set can0 name helga
> [insert another CAN device: again 'can0']
>=20
> Registering 'can0-tx' led trigger will fail for the second CAN device,
> since that led trigger name is already reserved for CAN device 'helga'.=


Good point.

> I'm not sure how to fix such.
> If 'rx' & 'tx' may be combined, reusing the netdev name may be possible=
?
> Just wild thinking ...

I think the device's name (not netdev) is unique in the system and
cannot be changed.

On my device tree enabled mx28 I'm talking about the "80032000.can" in:

> dmesg |grep flexcan
> flexcan 80032000.can: device registered (reg_base=3Df5032000, irq=3D8)
> flexcan 80034000.can: device registered (reg_base=3Df5034000, irq=3D9)

> $ ls /sys/bus/platform/devices/*can* -d
> /sys/bus/platform/devices/80032000.can
> /sys/bus/platform/devices/80034000.can

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig00580F959376127700432EB7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlA3ZVQACgkQjTAFq1RaXHPn2QCfVli8vdZlQYkFUj1pYHIFApu/
E3cAn0uD+4U/IBwv81M5QwanGlmJ6T4Q
=gUEp
-----END PGP SIGNATURE-----

--------------enig00580F959376127700432EB7--
