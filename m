Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab2FKEJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 00:09:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35389 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2FKEJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 00:09:40 -0400
Date: Mon, 11 Jun 2012 12:09:28 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120611040927.GJ4218@opensource.wolfsonmicro.com>
References: <1339147304.5216.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="utPK4TBebyzZxMrE"
Content-Disposition: inline
In-Reply-To: <1339147304.5216.1.camel@phoenix>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFT] regulator: max77686: Fix the delay time for
 set_voltage_time_sel
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--utPK4TBebyzZxMrE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 05:21:44PM +0800, Axel Lin wrote:
> rdev->desc->uV_step * abs(new_selector - old_selector) returns uV.
> The unit of ramp_rate is mV/us.
> Thus 1000 should be multiplied.

Applied, thanks.

--utPK4TBebyzZxMrE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1W9xAAoJEBus8iNuMP3dnRUQAIBQ5wviMJZpo4YfgXwlekj6
s4/82E3vzh6Y5obQEe1CovQ1LtcaAAb8OygCpUj92iG/dmaVttf5/+m3YH5tpONU
mONh/rlvFDiL3Ps2oVX2IghyjYdVK2Ntx9/xhAJq3hnv0OpyjZ5kbNNQNI5c+ddA
UiQtEvNCYYqkSrPN3nbHZmcLWXgLaERcdO368qKWqOcEgJLrocVvvm1xx/ZrmuFi
4PV7JtLEJCHvRC7mt/sAiwYIFLD0E9W64Sskp0DFBOf48GuYmL+Zo5QsZS2YQ+Yo
3sBnWa8Gbqa9mKp3OdOYk/iUQ6mD+583uWtbdiVD4rD4b/uNesO24auzlh72yS5N
DRccQPZ05e0gAuNMAMkVuLTNwGIndHAeojGDSuNT2KJ456mB0tDAqE3cmJqGbrM/
4pZOGcCtLXbclUWMH7WXwM/Ka9e/qJeiV685MsBgVYeNa7hgAzOHSM5iuMeXQVPr
NSypqjsmXm5hNbko81XwunITMbBWw9ZIGhcjkJEmQVSCjnrZ+w13Uy2HDr6mJw2i
U9e3XZHvqJ3w001s7uVl/IFq3Qhy5+c5LwnKSVJ++BXtVmwCoCradupuJ3Gwtxdu
qzN+aHcTs3uoVOJdAm0slqJsQ1bZY81acnitSQRyDdsNjtVanh5Kj5a7s+G6/mYY
ymwKYJ7fTXSQqfi3rAYW
=t32+
-----END PGP SIGNATURE-----

--utPK4TBebyzZxMrE--
