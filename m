Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2KNBW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:22:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51480 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab2KNBW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:22:26 -0500
Date: Wed, 14 Nov 2012 10:22:18 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
Message-ID: <20121114012217.GE4415@opensource.wolfsonmicro.com>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
 <1352646721-8350-2-git-send-email-ldewangan@nvidia.com>
 <20121113074623.GL18224@opensource.wolfsonmicro.com>
 <50A287F2.4070008@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3XA6nns4nE4KvaS/"
Content-Disposition: inline
In-Reply-To: <50A287F2.4070008@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3XA6nns4nE4KvaS/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 11:18:34PM +0530, Laxman Dewangan wrote:
> On Tuesday 13 November 2012 01:16 PM, Mark Brown wrote:

> >I'm not sure your wake_base setting is sane here - this is expected to
> >be a register.  If it is a register why is it not a #define?

> There is no wake register. Here I kept for the incerease the wake
> conut so that irq_set_irq_wake() can be called.

So you want to write to random registers in the chip instead...  that
doesn't seem like a terribly clever idea.

> I think it is also not correct after change
> regmap: irq: initialize all irqs to wake disabled

> I need to set the irq_wake(0 without the register.

I can't really parse any of the above, sorry.

> There is 2 sets of registers which need to be configure, MASK and
> LINE enable.

So what does the second one do?

--3XA6nns4nE4KvaS/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQovJCAAoJELSic+t+oim9kcAP/3WBGB0h1Hpui6h0I82cuN7g
fEEFnUm2jhngeAPyLctzmnzcKKIzoF+4l/lFVth9ycyBOxM4XjmAEqUSfCoPui7E
TphIcAtzp7RcdPhBl40+iPukCnlwckReSYvUzwzENt4kbEMvJYkdJsPGQqyGRo/Q
iJ7YCpOhYmvAtKkIUDHAEhu3FrMTpwXGuX7vqE8aCELOFKfDy+QCA53VrNmbB2Rr
wm5N5ab8k2+XxspV6F3EVC043D/XIM1KADGIPJgG5QvOSvqAIxXAR+BzyWOMA0aV
/X9ZlmNaW0b2aJGl/vcpFkdIA9NpqgKKbztb1cvk+oUac8ogwzDRKhIeDdbXqGk8
krBx6Ad/tvdr5zSzev4ceiY5xJGGHlkNXp3aQ8zxQLpghpkW/ZQpn82TBXurIhUK
ZAnhgYlPgkIhOOfCQSK3rQT3QRBjIGDL10vR67mQ0vdE/hGGXY0zGbRqkoaKL3G8
aLb39xcseVoeo6LEDQ3OF0bqI7c6VG0W2/8wTp9o2REOrXH/YLlBySk8uX+9b0gi
9wQOWy+IqTvgoN15WR9T9tGwUCfIQRcGBXxI9Zr6ZfzV+2jlUrn3+m+gOFVaycMO
iacfADtlbrGP65XdOX79IsPO8dWXu3mNl9vkNtJv46Nt+S2JKJCdgUmaVZgV+ydi
TmevMu4rchuXbcvCUb7w
=08kG
-----END PGP SIGNATURE-----

--3XA6nns4nE4KvaS/--
