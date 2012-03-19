Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032639Ab2CSTHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:07:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40845 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032553Ab2CSTHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:07:49 -0400
Date: Mon, 19 Mar 2012 19:07:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v8] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20120319190745.GF12384@opensource.wolfsonmicro.com>
References: <20120317215202.GI3315@opensource.wolfsonmicro.com>
 <1332158368-14786-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <1332158368-14786-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 19, 2012 at 08:59:28PM +0900, Tomoya MORINAGA wrote:
> ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
> resistance to voltage noise. On chip regulator realizes power supply rejection

Applied, thanks, but:

 - Stop sending patches as followups to old patches, this really doesn't
 - Do try to use subject lines for your patches which are consistent
   with the subsystem.

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZ4P6AAoJEBus8iNuMP3dPlcP/iaF2K/SPpBBZTxQJPJVw8qj
mxHvdDyY7wtFREvC/dFGRNodi5p5119Pdg5TYMStzmA/IMTLLqeK3j+qiymnKTUb
CyedRuqOGqzXJejiuDYS0ZJg1ptzE48mA7+hbCLXd5I6TAOb13iA2J+GFXlk4PkB
ef7gRYN+zopOIF1wU7X0u+NQw6cuKvJo6bhHdrXeYZH8YQ2Q7+h+OxM2sQK3SxSb
EZqMgSwtits97Lw3NfPb3dZoFYQd6wIaiacraGytAJsR2vncG0YKmg4mh4+RH0/M
7BccyMPDdCgtzAKL8y3UgpQ5EPg3WGwLVRQTloJi7rgXH32JK3fsinStrkfu2SQC
pxWWFxGDuy8rUaevnoZ9myziPc+BM1kuhDo/m5ZBIRRmaNUAnOsWVxQ8MJeRddqv
8A/MJiEOzTPRzy0zhAbkzM6stSDlwP1lpyABtN2iOXNn3vZe+ohn23lGV3ENNrT4
CUisYwyqOX67eCn95GMqhsr2xHxMidCD4bcMM90sYzWaUrALRiV0FlpYwnG+8yVM
bzGMVd+RRCgAtX9S21tqJKBPMb+9whFngYtK60N6a8pBEv58PeV1G6TnNvmTPjoa
fJzo1XQOapBXo5L7GHMCiUzFavJEMiBMAXkl30RP0OD/gMeuV/Diniv/dXkba4B4
9QXfHxrN9w72fUUzOy5S
=Ij3Z
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
