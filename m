Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2HPNHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:07:49 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:43923 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932088Ab2HPNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:07:48 -0400
Date: Thu, 16 Aug 2012 16:03:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] scripts/modpost: add a exception for USB gadget
 drivers
Message-ID: <20120816130344.GD26408@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345060759-18091-1-git-send-email-bigeasy@linutronix.de>
 <1345060759-18091-3-git-send-email-bigeasy@linutronix.de>
 <CAAe_U6KyAt8KuzOR0dpPmN0NFDLUupzCmdfB=d5ibbN_m4nFTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Content-Disposition: inline
In-Reply-To: <CAAe_U6KyAt8KuzOR0dpPmN0NFDLUupzCmdfB=d5ibbN_m4nFTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 06:35:07PM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi Sebastian,
>=20
> On Thu, Aug 16, 2012 at 1:29 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> > The "driver" struct for a gadget driver is named *_driver. On module
> > load, the gadget expects a UDC driver to be loaded and avaiable. If this
> > is not the case =3D> -ENODEV and bye bye. That means that the gadget
> Will this be taken care of in your future series (with configfs?).
> There might be cases when your gadget driver gets loaded before the
> UDC driver.

with configfs that won't be a problem because even though function
drivers are loaded, they won't bind to any controller until we tell them
to through configfs. IOW, functions will only bind to UDCs after we
assign them to a particular usb interface through configfs.

--=20
balbi

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQLO+wAAoJEIaOsuA1yqREULYP/RmJHoyN3oezLo+xt15fVR6l
we94SZkY3BKF1bZaEr37BD/M0kWQI0Q2B8Chv9EgbB3vYfzv4A4/S9dGCc+TVzer
uxJJQDW5lD+N+9ENQYp6zPF+uO4zhFEIu1QXiO+k+FfQxJr4beBzmKyOqw04xR/s
ScvcLUBZFe+GyCrvLd9OiuWv0c8QH485d3FOsX0MLv/7KatyFxftkObISNRpBArD
n5Q/kIPG3z0P7iVS1m0G73roGq4a/2lZRQyq0DlJbvrr26XAYrsvl5yOwH6rr65J
qxX0gNjKP5mBeT3AH7SCBRwib4qUuoyIDwzr0OZGyAKvkC3CUDlJMB3eT97XDkTv
JFxVUaZFPZb9X2zgtpCNCu20Hfe/L1xes5CL/M/InqbRIvlFfOgyABQgpSUeULO/
1L4DPOhFHEURSIgkZ0EZh2ggw7J1zjSlGe10yE+tBs/is8gAltbapo2H4qDlIQYu
xakCuSZl+3EiYDTqP4cmvy1ZcVUhx+g5K1KEUYs+of0/iJH9Nl1iJhpr3IF6tu6q
GqScRe51oNJzJByK3PMjECHYsiXfNz8+aleicNyhrkUkmvFRlRvXOLIrggOUXr+a
Eltq1HcIykt8nLJ/AX3Lxm0pOJfrKwOlFPcyVEB3fQgHRH6kbs8j+QlyLV+BQUKi
wHvFsTvxTewGPQ8RmX2s
=iRWT
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
