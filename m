Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2K2Lkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:40:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47905 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab2K2Lke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:40:34 -0500
Date: Thu, 29 Nov 2012 11:40:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Correct default for LDO1_CONTROL_2
Message-ID: <20121129114032.GI32691@opensource.wolfsonmicro.com>
References: <1354128448-12664-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20121129111827.GB22736@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WdPYQQQ4lIWZ4ZWi"
Content-Disposition: inline
In-Reply-To: <20121129111827.GB22736@opensource.wolfsonmicro.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WdPYQQQ4lIWZ4ZWi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 11:18:27AM +0000, Charles Keepax wrote:
> On Wed, Nov 28, 2012 at 06:47:28PM +0000, Mark Brown wrote:

> > +	{ 0x00000212, 0x0001 },   /* R530   - LDO1 Control 2 */=20

> The default for this register is changed in the register patch to
> zero should we not leave this setting at zero to match?

The patch file is different for newer revs, I suspect we will be
changing the patch for rev A to follow suit.

--WdPYQQQ4lIWZ4ZWi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQt0dbAAoJELSic+t+oim9mgQP/0vhox6lFw1CkpEZUir+V0s7
geVP5J67SWjNXKF2oBV9to/Ljh1soiVTIW1aMfMzkmk/V8PM6z8NC6y/8baO4ope
capWUN/XiWo3v4B9WA9kD5yRhKl8yeZ+qCoOvofe31mZEiA4F/j49UH+ORtUrlcx
WiVywW2rTJzr8U74DxbuL3R/n3JXHNvJ59IkEe+TNn5099jnhURyAvmtlcrgNWd9
xd0uDY/wWzrTtE86BC1Cbymihk0Ye4Ra4BKMDNZI0Bkz78QYPtIeFFuSIJkBCKzw
+nwqbOWtA7Phd6eKXYdvYEud9KuTtJDXg+uEAXwcPnqoUE5PX6ui14zdVqB+t3Bf
xVE0FBNciPJNXrduh8WkOdgtWIe4yHe2us3oHj/JfH9doFMDVW3HqlzDP6h5yNA2
8Ty07Sok8rNHSrbbJmBpWpMVRj//ftOZceTX8Y9AsN+yAKAOmWe8tNdspnnmOPsq
iyEmXfQpwZg5hFsvyqgphrtyvfm1HocFW4biaIZV9F+/UCMQa9omDtA4U7ZG7bCa
3+FeAKihrmu+QECi9UUIKMr+ufGTzUNi/J2CiOmk49LtHyJbI6jNHkuqqs0JFfrD
PUOBrGFDbK+/h4jEu4qLrjF56eTEGa9VM/8LQL4dHSTlsGD70icQhuxPDbgdcLff
g+zI2WPdJtenBV2d8bqp
=F9/j
-----END PGP SIGNATURE-----

--WdPYQQQ4lIWZ4ZWi--
