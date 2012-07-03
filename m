Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2GCKKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:10:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52553 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab2GCKKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:10:41 -0400
Date: Tue, 3 Jul 2012 10:40:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        =?utf-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Subject: Re: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona
 class devices
Message-ID: <20120703094029.GC29030@opensource.wolfsonmicro.com>
References: <4681354.107331341300035007.JavaMail.weblogic@epml05>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Content-Disposition: inline
In-Reply-To: <4681354.107331341300035007.JavaMail.weblogic@epml05>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 07:20:38AM +0000, MyungJoo Ham wrote:

You should fix your mailer to word wrap within paragraphs, I've reflowed
your text for legibility.

> Though extcon-arizona.c itself does not seem to have problems, when I
> add the patches from your repository
> (http://git.kernel.org/?p=linux/kernel/git/broonie/misc.git;a=commit;h=3afbac957e3c59037a4ecaf19d68f6c8104299fc),

Please provide human readable descriptions of things!

> I get compiler errors if MFD_ARIZONA is enabled in order to enable
> EXTCON_ARIZONA. (No other Arizona-related devices are enabled; I don't
> have any of them anyway) This is not an issue w/ extcon-arizona.c, but
> I just wanted to let you know.

Note the cover letter for the series...

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8r4FAAoJEBus8iNuMP3dZLMQAJOu8S8QxTcf6HDMJTTyV//P
mA9z2M2yC0AMJMEY9yCuLYWlFy/Vqv3rvEBX3yzY4XebyL7cf53f2GD1y73AYwas
CPznYnJawDIKxVc6IPS/hygoT25BRKuHOCfnhCWj5blK95+KwLWWRA8QqdOZ1KgD
4kMWydsouCkw0h0u+y9aXOvSWE7IM0DDfsz4eiaNvGo+WA45SeDK3ouI7O4cAx8y
qs+ZMkSOGL0/w1jGqFRG2QnbIxQCPRAHcgT//3uo0G98pvPsNREORcB9/1DMhM0L
fS3cBuRFGI+e4HHg91doCtN6euYzHsbXwVvb6mCH1BgsUsrlCrIL87xEmvrXXr50
PIqzCoj/PyBsRJLb0vtfHLdfUwdvN7jL0Ue/Abp25743pFqfvS5D5uwKL574bFeN
IR1nfpJ2qVIuhNDMmGL/xKNEgqye9zY8YM9OAsq0n5HED2aO+hAzBkYuGuBroTum
AXWi/cqHZ3ALpZfAB9k5ACjt7T52V5OhUeITnJgQ+jpkG5icJAQWBWz2hwSVxFFD
W7LPM3Ebxl7+laYJkUqG1/jSBRrH56FiopCE4Ip0+HQyFEdrhSJg1u2UgzQ8zpM9
CAcJwcCLfh5oftk0fZZOb8QaYdPUV7uke5nVTQ7KUnZZkggB8aO/n/ZF7uzhZ8Lp
GpH0CClaHoAYynTBV2Nw
=5aC+
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
