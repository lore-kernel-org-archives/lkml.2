Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755Ab2FEKiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:38:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44034 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab2FEKit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:38:49 -0400
Date: Tue, 5 Jun 2012 11:38:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
Message-ID: <20120605103846.GQ23408@opensource.wolfsonmicro.com>
References: <20120530100302.GD9947@opensource.wolfsonmicro.com>
 <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com>
 <20120530121547.GJ9947@opensource.wolfsonmicro.com>
 <4FC63632.4030504@linaro.org>
 <20120530151119.GN9947@opensource.wolfsonmicro.com>
 <4FC63B39.6040905@linaro.org>
 <20120530164152.GP9947@opensource.wolfsonmicro.com>
 <4FC846CC.20801@linaro.org>
 <20120601084850.GJ24139@opensource.wolfsonmicro.com>
 <4FCDDFFC.3000902@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7a4X6VOqfbl9xMrG"
Content-Disposition: inline
In-Reply-To: <4FCDDFFC.3000902@linaro.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7a4X6VOqfbl9xMrG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2012 at 11:31:24AM +0100, Lee Jones wrote:
> On 01/06/12 09:48, Mark Brown wrote:

> >What makes you say the two are equivalent?  The former is a reference
> >from a consumer device to a named regulator while the latter is a
> >reference from a regulator to a named consumer.

> I mean they both link regulator<->consumer and apply the name "vmmc"
> to the supply, or am I missing something / getting confused?

You're missing something - note what I say above about the direction the
mapping is done in, and consider what happens if we've got two of the
same PMIC down in a system.

--7a4X6VOqfbl9xMrG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzeGkAAoJEBus8iNuMP3dMd8P/jzYk3RCYJj51m7y3Nk0z9MO
5OmSld7Xc4QnJA+hSTXQ4VOeXHstVrE/aKFUFDzIM/7X0kv/xXlNwyr/Ot/fA+JG
FvNPBMq51iM4T9kS6L2qtWxYpYJjIgmfi0IAX9e6k14rmP4gRVCZRuqmq6PckceD
fe80WfuYQwJb5rrSy2ma8INM92u5ooM7dhN3Q90wWiWwd2Yw2dA3z9iHfSMoaBj2
Zkrm7EcDHZTyjFD25udEVu9Qf+nWsXIt5Td+gd9bDwkqa2yHkXW9uAlo2opuB6LE
5fPel5w7R8toOztR1udsMf5WqDZfYq8BTf/LDMui+GsU//QA0Zlaz3iFfhnn24v5
a0MfoayWAhwiY5bYD1ixYUhJglJQlwl7S/eXLtVEvVPNbzOCE9d67908cBNxRiA0
FYRhDnFa0PdpTVuyqLivPrkOWa5eU03sVQt7KSfAmGad2WRmwT8WunWVBKHagDST
ho5DntAOVfvBZLuExTPyLEzlDrr6eO5AAIv4zZlVF1ccNmzVhSdMndloIKYyS1JS
RCO1FzhhDgyqioY708C5URknzDgpZ8ocAZRjPfI3WlFqxEXHMVzp+dxCABXSVEAc
gf5ThX+r3FjRzrEolw/+ItVYnymCLfAyirt/4LUBL1srkyhK7TSmQC5KSDqBp2ei
eUJlSpa57Vj4vjkg2gy7
=gGTp
-----END PGP SIGNATURE-----

--7a4X6VOqfbl9xMrG--
