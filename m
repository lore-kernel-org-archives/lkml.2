Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2HCNe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:34:56 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:53369 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374Ab2HCNev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:34:51 -0400
Date: Fri, 3 Aug 2012 16:31:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 05/11] drivers: usb: twl6030: Add dt support for
 twl6030 usb
Message-ID: <20120803133122.GG8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-6-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-6-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 02:39:54PM +0530, Kishon Vijay Abraham I wrote:
> Add device tree support for twl6030 usb driver.
> Update the Documentation with device tree binding information.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

This looks great too. I can take this without any dependencies on the
rest of the series, I believe. Right ??

--=20
balbi

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9KqAAoJEIaOsuA1yqREHgYP/i+9pjKJe1xAR6LRLEirNEcT
qkLelLlZXpjmqxJ2r4nwGlFYaHJdqpT4I6uZ/7cftIK66XZk9XDTRmX6TndbmxYd
twIjbJ/DtaP0goyFvTbPMKRiLAv9PQ/iz8oNy0qjku9/u/nEzJZm8+Ehp1C9nHxi
oODPnbSGJIKMOmQHFFwc7e/yuedxtcVy2jIJzmWc4vD5AJsPYS/eA+YYx7abiaS3
GqHkjEXTKVDL6/0euqkwkP0NUgp9TpD72vHhuhCrjl7uCcKwGhRXoGxNmY+uFRvv
eykrBOnZyJg137vL7P+LOVaKSl2/woSwomA/yyp9BkQbGsi3dgg7huu6TB1a7FLK
a0sHWkvoxv8BaqMkbDtX/kDaL81iPRhJmVyWvXW/yhkayy4WyZCycJ92lnnbpc76
C977LYxZAx3A0wunFt1IWywmbLGSJs2E4RR6rCDCod/TXUcmtCKcCr6vVvsdvbQ3
o+RnXSNRqZIPtiqIQGx264HZhizXvq/6CrGAemqUjq4FX4RY4ewWtr4N1j/fgNJT
ItvA7AQSTN9K3X/zsWd5D//UB3wh2EQPa7MQ2XbIJqPz5mMRambEBOohht7HBC4q
N33eKmiRqnPs2YccAIWn4mCE30fAkVKb3X1gjbchb0RozqvNM3b09CsQWAskhswo
nYPu5e0MMQQXYB/roUID
=Riso
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
