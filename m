Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2ECQ5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:57:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab2ECQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:57:53 -0400
Date: Thu, 3 May 2012 17:57:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503165748.GS3955@opensource.wolfsonmicro.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
 <20120503112803.GA15752@localhost>
 <20120503113801.GE3955@opensource.wolfsonmicro.com>
 <20120503150040.GC15752@localhost>
 <20120503152407.GK3955@opensource.wolfsonmicro.com>
 <20120503165437.GF15752@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIYaQRZjygY6fA2m"
Content-Disposition: inline
In-Reply-To: <20120503165437.GF15752@localhost>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIYaQRZjygY6fA2m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 06:54:37PM +0200, Johan Hovold wrote:
> On Thu, May 03, 2012 at 04:24:07PM +0100, Mark Brown wrote:

> > I'm not sure exactly which control that is?

> That would be the output_lvled[n] (n = 1..5) attributes. For example, to
> have all five low-voltage sinks blink synchronously, you could assign 0
> to all these five attributes, and set a timer trigger for the led device
> which has id 0.

Sorry, I meant "what exactly does this do in hardware".

--DIYaQRZjygY6fA2m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPorkBAAoJEBus8iNuMP3dAFcQAIDn9y+QqdyXWfOyamENxpn+
EznbBHVWS7UKEUoaGJc6IB488MlP15tEcgfdJ6KN8fznOWH9Upi63DkJMj28QT3T
Q8na/BrmKLL8383jjW1st+owndkTIbhTv6eTKE9Q6q/59tzRHAYBE0/azp6VVhSY
phSd9xEI42yooNagYxDUQb7z2blebN2qnt9ZPus7cBZSfKagqRzLgj7j6fNxELdX
j9GRLuvvlvNzbzEXkmq2G5GwO4W0hEAxayplj/Rv+8tsX752JAJM+U92a6izfqFP
Tx0IQES8YzsJcK/Wfx2k9iAKFy3RwWUo8jxLf2kSHcQJEYr4FR1aj51lS9XhZ4Qh
8+fzyoRF7tgqXAftk9PRNlsD+lVeqHol0YgDyZqnWUmPgQQcFWjy4hAxg5QSEOrD
iLav/ieomiPmeg0mv+adXTQsaWX4c3ocyvHCL+ZZJrHKHC78OVCaqOgrUrLyuba8
UxAKSUZAIGJk+OlN7VHr41D094FcjpPlW6FpkmN4o6g4KnA4R0BYLzm2Znbs9+ov
0D5IllRtbiWkJhTI4plCoIUXRZQMgHsDiqJNSCkMpUj5unmL+rdVEtN/BRvlQ/Uz
2DkedCERlR2EUF6/Wsmargh09JNWioDrsasBIuwsGX79Bico9jfBUPeOwEsVq7yT
P93gUAstaVHqo7/QlKEa
=SEVL
-----END PGP SIGNATURE-----

--DIYaQRZjygY6fA2m--
