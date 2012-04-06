Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2DFOtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:49:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33592 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364Ab2DFOtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:49:20 -0400
Date: Fri, 6 Apr 2012 15:49:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
Message-ID: <20120406144917.GE19424@opensource.wolfsonmicro.com>
References: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333552489-27694-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120406044832.7C80D3E0ED5@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AsxXAMtlQ5JHofzM"
Content-Disposition: inline
In-Reply-To: <20120406044832.7C80D3E0ED5@localhost>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AsxXAMtlQ5JHofzM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 05, 2012 at 09:48:32PM -0700, Grant Likely wrote:

> Can we make devm_gpio_request a static inline wrapper around
> devm_gpio_request_one() with the flags field set to '0'?  I don't liek
> the duplication of this function.

> Similarily, gpio_request() should actually be a static inline around
> gpio_request_one() instead of the other way around as it is currently
> written.

Yeah, I couldn't understand why the non-managed functions were written
in this way so I followed the same pattern when I added the managed one
assuming that the original code was sane.

--AsxXAMtlQ5JHofzM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfwJkAAoJEBus8iNuMP3dWqMP/R1pImDgO20RMeoQsayvqV+D
qXJRGurNYGvMMECBeeiOjW/oZwGpwWLzNv5ugfobNMBjMnW/pxmHqfsJipIjqnDj
dRuD8JEiruzYCkf/qXQ2RPd87kH/6/Kn/EwM08ROgX1OH2VLJqZ2uhV3DhATpelI
rBCbDFY+lrmsroxn3NtNdhmndcVUu0pfEohFBl1qHGm6AaD9+R8RBrwmupJIZFo5
blRdQZLeGCTIlIxdDAbCV2cEUK0MZCEdH9Oq8GwmVBrTwKPIUyfDbppnb1Q6E6oP
JUZp1e48wM2H/1SuWqSz3dd8QPfEJSRfc0WVu2Inb+mOsGDy4xFZh2TDzilkfkD1
MbKp/yjBDk913ni3+1FRzX0KbegAALFOrjRP0zWOR/K+q8pL8GYV5N9iFn0PhC4s
TuEC6RjJPAi7YhjqKGi1sc1f3JqGHxe6+vnBZNAv6MVRlZAbpKuAu7EM9hBHHx0T
j1NIaRXEUiseo9XU6cBkm6PYZxaS4huP17sPqQrmxvCu93GmHWizRViaBfA9f6ab
jr7swB9oNyNTD951G2Cy7rkhc5sNEos4em0NKp0qDUq9FtUxPAtIBAV0CQcXJtfQ
w7Bfp39Q3R4LS6avZM+/Jw7lA2t7KBT1ZdXhRXqGA86I0ly0ILDJ9TNbXvOO/GCU
icHtgqJZ6qWDQ/5Hk2fi
=wRqP
-----END PGP SIGNATURE-----

--AsxXAMtlQ5JHofzM--
