Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2CLSck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:32:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59894 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487Ab2CLSci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:32:38 -0400
Date: Mon, 12 Mar 2012 18:32:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: simon@mungewell.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
Message-ID: <20120312183235.GA28451@opensource.wolfsonmicro.com>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>
 <alpine.LNX.2.00.1203121645050.18356@pobox.suse.cz>
 <be2be8d04b58ce75fcba9798fcb4e4fa.squirrel@mungewell.org>
 <20120312180738.GD14020@sirena.org.uk>
 <3391c87c6cc142e1b50b73eb78e70dc8.squirrel@mungewell.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <3391c87c6cc142e1b50b73eb78e70dc8.squirrel@mungewell.org>
X-Cookie: Beware the one behind you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 12, 2012 at 02:19:25PM -0400, simon@mungewell.org wrote:
> > On Mon, Mar 12, 2012 at 02:04:14PM -0400, simon@mungewell.org wrote:

> >> At the moment you'd just drive the LEDs simply, ie:
> >> $ echo 31 > /sys/bus/hid/devices/.../leds

> > Shouldn't this be using the LED subsystem the kernel already has?

> The LED subsystem appears to be aim at controller chips (ie. lp3944) which
> are connected to a bus (I2C) in a generalised form. I guess people might
> be doing 'blinken light' type systems.

Not really, it's aimed at supporting LEDs in general.  Obviously most of
the drivers are for specific controller chips which makes them more
visible but there's also things like the triggers.

> The LEDs on the G27 are very much more specific, mounted on the yoke of
> the gaming wheel.

> Would this require the use/complexity of the LED subsystem?

Well, it'd mean that applications that know how to drive LEDs will be
able to use the LEDs on this wheel with less per device knowledge which
seems like a useful thing and if someone wants to remap a LED to "new
mail" or whatever that'll be easier (nethack has the mailer daemon
deliver a scroll of mail!).

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXkEqAAoJEBus8iNuMP3djBkP/jxZCk2PgsUOItZpHEMOXp80
AV/LUerGtCVzjn1ApxpbQO3b+NH3vMoA2fzjSlDzdJs3DJIynV6kucK8f1eV5yzL
Lqk4eV4yo8EiH9r37qjhg/spB7OoNLeGMdGdg1u9kerhujz+tF85/nAKdBFoKn9E
YyBVxRP618U9K3V8yASBVGJ0RbG+MM3NvvqZklRx/iaGKFRHXbk03quw2w28GsOZ
K/FRdvVpJNKa5Ukr3s9jH8y7TfWBMiOauRE6WjPinxiegBSFRC2fN/1H+utJm1CQ
tnnQEq4FZ5RbmzjPb6Zy+9xV8dsYKeDF25nm79eD9nzKoYKBKdE3b4MwKoYdw+oP
qAHraKeK1On34dj0QwCAhyISF0hpZ3TvgyvrtIdi4JtWE9uG8lBCVuVH4CBYRoVe
7Y0T3H6p+CKsoZOQpr2pyRPoicIkJogv0MIt3LkqjgE1/CCgaKliE/ttC+jAnUPc
RVsqxBI1oOwnYPANQb2V2AcPWZupJg3dLpWxKZtrd/QaOWkabS7TCF1j41ZZnoGE
T9RbQgrWNaF7E/lh2Ygcz7RyrDjO4XETDSmPRuOoVcq8xuMPowXoMv8ZVIi/9DBQ
ZNJyFe5mw6EdrKVFPlWb9/BZCs+DxVYOPuJ9a6S1kJf+glnQqPJfeCj5C5y8dxCw
buD/PExmtNuxErL9b451
=DiJy
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
