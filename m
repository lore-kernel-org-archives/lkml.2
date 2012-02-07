Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2BGLNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:13:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33723 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858Ab2BGLNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:13:12 -0500
Date: Tue, 7 Feb 2012 11:13:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "x86@kernel.org" <x86@kernel.org>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v5 2/5] x86/platform: (TS-5500) add GPIO support
Message-ID: <20120207111309.GB3332@opensource.wolfsonmicro.com>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1328130344-18836-3-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20120201213025.53d820d2@pyramind.ukuu.org.uk>
 <1328211236.2261.152.camel@groeck-laptop>
 <20120206153742.GE10173@sirena.org.uk>
 <20120206152307.7d1fb316@v0nbox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20120206152307.7d1fb316@v0nbox>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 06, 2012 at 03:23:07PM -0500, Vivien Didelot wrote:

> I Cc Richard Purdie, to have his maintainer view on the platform LED
> declaration. Is it ok in the ts5500_led.c platform file, or should it
> better be moved into drivers/leds/leds-ts5500.c, or maybe directly
> declared in the main ts5500.c platform code?

It would normally be done in arch/ code.  I'm not sure if Richard will
get back to you, he's been inactive lately (working on Yocto stuff
instead).

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMQc/AAoJEBus8iNuMP3dBNAP/0qLlD6N4BF5WpDZ0VV2SyAb
y73xhuKqTldj8zkpjRyjlOo7lIiZWypLfPgyPxFkp9FDSSd+azEp/NtDXB8XPapU
XsbJgOXjNURQqn9wz6tZbbAqvAi6ur/4dGjYJxkaLqbnKaLyOuWJAAn8SfiBOgrX
doW88tZusUZMjxJltG3K9pSS9IM5btYr23RGM8nB62P/clVZUQZrYsgtx+rhDrWt
p9UVCCmw5aTNEpebMe9CRqm5Uyd5enZ2RagKmKbNfyyvB2mONk7BG1BpQrDejivY
i5qlkoCOzEdNQTvXXtpv+dW41eAqd6r5CddnMY9kloNYaQxmszwl20tuxo4ss13j
MukQ4LOBbU7iByRiMlzPaYe83lBZzyMIA5hpI0cEYZY82dJMXHk5SIliIYXeAif1
rQC7cQIwqATDbZ1DIQlRSri2AB59OCPngF/30MKuvSi5EBA1vbtngaplqp3yCE7H
fJV9EKDTIPbdDTxYoO6yb38tCRrysqdjVjae02MwUdwcF0UlKr53u5O1K1xQ+l3X
BM800e5MLnUzLrlJPEoedGNENUXI5HHPGseUzUCh7jNoTbEMp3OJwSs0t4fAbdAK
DXHeqfHuSSyBlprSIMusRe+Edt9GOqJDuADJrsnWdTcI1IhZieGQSm8xHMkim32d
hoiBJtY9N5yLYfNSLWLQ
=D7Se
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
