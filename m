Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539Ab2J0WGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:06:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43027 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232Ab2J0WGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:06:46 -0400
Date: Sat, 27 Oct 2012 23:06:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Scott Wood <scottwood@freescale.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4 REPOST 2/2] kbuild: run the pre-processor on *.dts
 files
Message-ID: <20121027220638.GK4564@opensource.wolfsonmicro.com>
References: <1351279797-16450-1-git-send-email-swarren@wwwdotorg.org>
 <1351279797-16450-2-git-send-email-swarren@wwwdotorg.org>
 <508AEB3E.6090405@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jl+DbTnyraiZ/loT"
Content-Disposition: inline
In-Reply-To: <508AEB3E.6090405@gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Jl+DbTnyraiZ/loT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 26, 2012 at 02:57:50PM -0500, Rob Herring wrote:

> Like I said previously, I think we first need guidelines on what is and
> isn't acceptable use of C preprocessor in dts files.

Didn't we already say that it was just the same rules as for things tht
get included in .S files?  Besides for plain .dts files (as opposed to
.dtsi files) it seems like if people break things they get to keep all
the pieces without disrupting other people too much.

--Jl+DbTnyraiZ/loT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjFrlAAoJELSic+t+oim9iD0P/1Au8aMgersUUADYNp9shCZq
8XAAQ1fU+gA+J3tTTgL7lJvRBeHwflnPunkorYf4dYx84mAD7n96HiFBZ4x5YWei
ceeHR67YTrQs5g9XOymAsjEWFsiCDdvug4j+IJLiMzTJ/LLFrj+tKnLazikpM7h/
zswjSeDQfl5w7lnP+y3MySBIUSWcpMeMHKC8MW3Jl6h2zAIsy/mSSsTpW1xjtMv2
lfclHSlzT3RCeregNlzPdltAQGHr8pkG59FTKn4N8a6EWHhzMUui5U0PtlmmyYLG
UPaHcJKwOria2DMCeYY728mSzMBnKTTNj11+vEvgxkNVs60rfS8dTbLferIUtK38
lTLEMp7xu45XKOLLRKhjUDPUlmH1vyLUTEGWY6lpOV1shSSqMVCP9zz5ORYUj+o6
o9LYH4cjRSoo9I4OO9fEwnXP5QUcMGjICu5A7XW6GneLp/hCKgb3XLGEKS1LDIkG
7NKma7OFdp9TNWJz5+ak4lgIg0x4u/j6YTro5wDnj81Bact7hELKy/s3trj+0vUp
2vcajFRn0EZejSMWq7lF2CMsYycFXQS1XEy4lMjhDoVzDpGAuebjLn3RmjS063O2
crq5MjAcMf3FuK7To4PAamqrwgOZpynWPy8zjxRi0kKBEaSINIIGRtS0WZUsro5T
lWClyWHIqfTjVAzzbXJF
=zCIY
-----END PGP SIGNATURE-----

--Jl+DbTnyraiZ/loT--
