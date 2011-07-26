Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1GZOwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:52:20 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48593 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab1GZOwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:52:10 -0400
Date: Tue, 26 Jul 2011 17:52:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Wendy Yuan-Hsin Chen(??????)" <yhchen@faraday-tech.com>, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] usb/fusb300: remove #if 0 block
Message-ID: <20110726145204.GC32582@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1310289795.git.joe@perches.com>
 <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com>
 <20110714080830.GA7149@linutronix.de>
 <B3F95056718EDE47B73D925D2FF34506782BC2@EX1.faraday.com.tw>
 <20110714103624.GG7149@linutronix.de>
 <B3F95056718EDE47B73D925D2FF34506782BDB@EX1.faraday.com.tw>
 <20110718083640.GB2837@legolas.emea.dhcp.ti.com>
 <B3F95056718EDE47B73D925D2FF34506782CB0@EX1.faraday.com.tw>
 <20110719194701.GD6323@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q7MaAb+MMjzLKrXy"
Content-Disposition: inline
In-Reply-To: <20110719194701.GD6323@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q7MaAb+MMjzLKrXy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2011 at 09:47:01PM +0200, Sebastian Andrzej Siewior wrote:
> The code in this block is unused and the Author is fine with removing:
> |These functions were used to debug unstable hw fifo while developing
> |fusb300.  It's much more stable now.
> |So these functions can be removed.
>=20
> Cc: "Wendy Yuan-Hsin Chen" <yhchen@faraday-tech.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

applied, thanks

--=20
balbi

--Q7MaAb+MMjzLKrXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLtSUAAoJEAv8Txj19kN19C0IAJnls1SoDYVN4f1jPFG4b6MA
JKIonn9hYpFRJ95zA+sl/ph6NkFD0/qmQ4pebWS0dGyDNUjEtZ/p0AHyW0YOrpMa
lxvkXSDUje1OEeAG7qRrIn+WO34ezy1OLii4CzFoDN4PYqNreSUsiv0va3YO10db
84VpWEvpeMKj3Ekui3+PxUi/ca3duRmJ7hBA6x5FatAXVJ15CdZnvRtk79jOXpbK
79gsfdxwMB2p8QHdOj1dmHBRrQgT+ESI9DSAdMtHoQYhtiJn6IZgDOzCNN43EcSg
zhUFHOjjULIfEHqKn2ZmLYVp/qizg5vrhFrWS+ulAO5Nd3Eaot6wos9z+Cpk+OI=
=C/F9
-----END PGP SIGNATURE-----

--Q7MaAb+MMjzLKrXy--
