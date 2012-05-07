Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2EGLXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:23:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52576 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755567Ab2EGLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:23:25 -0400
Date: Mon, 7 May 2012 12:23:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 4/4] regulator: tps62360: Provide settling time for
 voltage change
Message-ID: <20120507112321.GI4415@opensource.wolfsonmicro.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
 <1336376139-1048-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0NB0lE7sNnW8+0qW"
Content-Disposition: inline
In-Reply-To: <1336376139-1048-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0NB0lE7sNnW8+0qW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 01:05:39PM +0530, Laxman Dewangan wrote:
> Settling time is require when there is voltage output change.
> Implement set_voltage_time_sel() callback which returns delay time
> for voltage change to settle down to new value.

This is fine but depends on your previous stylistic change so won't
apply.  In general you should always try to order things so that there
are fewer dependencies at the start of the series - there's no actual
dependency between this and the stylistic changes you've made.

--0NB0lE7sNnW8+0qW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp7B4AAoJEBus8iNuMP3drzQP/0SsmaWMiElaj5oczEOIzVWk
Y8NGvipE2CW5SX/XBwfp7ztx0zCzsduSDKba25d7d56b+h5AljvgzEj+cMximYmp
dCMIZ88Yg4gth9VJW5FFojBgdd8YVH43ZvbefMS0bjcCytZWu2bNq2OWHQzdFueb
8E4sz68tr0vbDkT8EHBo0OQ4NHaE6Yic32jMFpqdxuClVBDG3+Ms1hgfjFSqD7h1
vdLMBWQ/ZSP+ghMC2enBuyc7FHAFmn96CBFv39vw4XSIVsrtAW5rYXeMa59HCXP3
EWVF1eBkoYGX+vkIYY08ooXWc9Jur7rq+AlNwHKfHrBYeNOhK4PGGGSCS++0vGJT
EeQ5yA0nMnNwNteZW4CwvAExLfkDFc46X+h5NuRpzp2Rs3txRR9ZECbqrrMkXBPD
wr8E2I8WeJhUJrRRr54Pfa0FdVl5VoDgiNr0uYNiqwwSUcAmc9xDg2NFDg/X8ZXj
glnJkbtJ1Mx0UwV81fGxd9AEH7Y/w90rHHQ0HAgz3iRKGjd6CYLAizZjO2l/pcCh
AHW09zR3UQ1PdcA2rHir7rdCHO4PuAdr37LDq3QuiLbVupuLaRyo94auCceVqfej
lha+PHKRoP/IyllTJUTiHKRC3VfKdzm2NuQrQG976Zr61gqcNFfEvHb0FBwscFlf
+8b+p/AiI9oVbslW91y7
=Tcyv
-----END PGP SIGNATURE-----

--0NB0lE7sNnW8+0qW--
