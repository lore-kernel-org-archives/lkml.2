Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2A0LTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:19:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54593 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab2A0LTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:19:35 -0500
Date: Fri, 27 Jan 2012 11:19:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
Message-ID: <20120127111932.GC32008@opensource.wolfsonmicro.com>
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1FD1A5.1060305@samsung.com>
 <20120125112602.GB2991@opensource.wolfsonmicro.com>
 <4F1FEF55.8030604@samsung.com>
 <20120125133254.GJ3687@opensource.wolfsonmicro.com>
 <4F217100.6020105@samsung.com>
 <20120126161744.GB19703@opensource.wolfsonmicro.com>
 <4F227530.3050708@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <4F227530.3050708@samsung.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 27, 2012 at 10:58:08AM +0100, Karol Lewandowski wrote:
> >>On 25.01.2012 12:22, Mark Brown wrote:

> >I'm sorry, this makes no sense.  Setting a value in the constraints is
> >not going to have any impact on the value reported by the driver, it
> >never has.

> ... with the exception of fixed regulator, that is. This is from
> where I got my flawed understanding.

Note also that this only happens for device tree - with platform data
there's separate platform data for the voltage.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIog6AAoJEBus8iNuMP3dIuIP/1PTCWySiFL1vi3384t6pLRz
bjCA6tcbkzDX6MoawnaJd/Utq+iaJPAfx6VopJHLmyDAkFRVBzolpQtR+ZrXFUoq
fFyWOGlCGnXlOHiKn1Wkjc+UwYDGiJasFckRMpiLF6Gn6r735n2617K1OIAFpykv
Nuy+snPfFTNLa9c53sJAytxKpgcQkPjuUxhCipYSwIcGxdxttEt2ZDBpSYi12qzj
T1Htc3mzmoeb+obczrmODFmvv+q0y8jjKQv8MnLBSd3Xbl+pmb0ejuySRRmc0Twz
R3uFmvA3HGjEQm800PckcXPLm9NZd2Qaag9AyQo/atJDwjU/o5tuqWZFc8NaBIRw
cT+3Eze7N+eXXFT+4NSrMhxnChCBcTBnw37gw6aON1jbiyWoj/G106MGPiGWFKOZ
PcHo6TOBjd3MMsoqjjyisi/GB7dbm6q+rSeNPnmuJXi6ZhqcXMw5Fo5kH7t35l7E
4KwV9cVjmLlTIp8QzfaxR/us3zornoV8zCMGdYS9PEqil26Xbe4UbShzSpuLIHUJ
7vuB2c+IvqhKluHaP28+P7HrRoYQayjVzMa9ukMpWDwMvMOAWL9CIWR5FQlc5iYY
AxHz3uxlUULuDS+5cCrdv6zwDld1DoEcXDQ/3llRIuhRMQDeJ0ngKjbDbo8iIBNe
TJT8bQns7+/BgadVbyWc
=aqBe
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
