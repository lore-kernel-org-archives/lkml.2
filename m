Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2FKDpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:45:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46087 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2FKDpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:45:06 -0400
Date: Mon, 11 Jun 2012 11:44:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120611034451.GG4218@opensource.wolfsonmicro.com>
References: <1339128184.8259.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhYGnrYv1PEJ5gA2"
Content-Disposition: inline
In-Reply-To: <1339128184.8259.1.camel@phoenix>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: max77686: Check pdata->num_regulators earlier
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nhYGnrYv1PEJ5gA2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 12:03:04PM +0800, Axel Lin wrote:
> If this driver only works when pdata->num_regulators == MAX77686_REGULATORS,
> let's check it earlier.

Applied, thanks.

--nhYGnrYv1PEJ5gA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1WmpAAoJEBus8iNuMP3dblUP/11qtrZaer4tjMxN54fCGjPi
ljAPPFYa2VWq9toLL6uhImGWReN3pPbLcn5lFLy+44llYDvFpqG52szSS8vgytRQ
XNgIW6LnVwI5dVF8Jy5vJsdP73f8MEacwJBYIknKoRvyaFKKJrG2SLEohqPNyx0c
/yUp/9+qJW+1lAnpet8VhLHh6DX4m82PajMADZU2XTX8V16oSJhu7VX98pViGTQ2
6Lo4Msp5LUDaT/ez+tia1HIHbNvqphFRAyEjO2gXVsHhVQIcx6WorWTIOHQ00YY5
qjg6FCNblwSRXQM5nnUUf3nJ+Jm6dPkRaV70u+PZ84WFrd2sbDmDfUW+uX75quCH
FMzdOjW8XZjqJRakR8i9JCPM5rpWQ7R2604WMoiWW9LdE+1uqK2tocuZM+aE3ury
Zoddqeed2dJEAihp4MF6x4iMCaGj/mcECxCTsDvjjKRYdhiHiwVVcVGbCmix5WOE
m0cTZRC7y//Zkh8iRf0F8fyG8eDDyRz9TYWheH73Fnyha870XElXymxWitnoPkmh
Ybw0acHHOWtCzXS5ryqgFI7M1RR0QuTJa2MqZswM1EhLPEQ7BxUSTTiXiOFfuryJ
Mt7f+1etIAF1YRyZnop7kcw98Z/W3+X66FaK1fWPaP9Uwo0tTkX2RYWgFDsqi0vZ
oAY95Jr5aVYIJhsOwr6D
=mGD6
-----END PGP SIGNATURE-----

--nhYGnrYv1PEJ5gA2--
