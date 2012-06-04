Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2FDH3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:29:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59654 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab2FDH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:29:36 -0400
Date: Mon, 4 Jun 2012 08:29:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rob Landley <rob@landley.net>
Cc: Sagar Dharia <sdharia@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, kheitke@codeaurora.org, marc@plastictigers.com,
        gclemson@audience.com, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ohad@wizery.com, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, rusty@rustcorp.com.au, joerg.roedel@amd.com,
        trenn@suse.de, ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20120604072933.GE26676@opensource.wolfsonmicro.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
 <4FCC280C.6030103@landley.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yb+qhiCg54lqZFXW"
Content-Disposition: inline
In-Reply-To: <4FCC280C.6030103@landley.net>
X-Cookie: You are number 6!  Who is number one?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yb+qhiCg54lqZFXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 03, 2012 at 10:14:20PM -0500, Rob Landley wrote:
> On 05/29/2012 08:11 PM, Sagar Dharia wrote:

> > SLIMbus replaces many digital audio buses and control buses by
> > providing flexible and dynamic bus-bandwidth between data-functions
> > and control-functions.

> So that's a really long way of saying "A bit like I2C but faster"?

No, it's replacing I2S (or whatever) too.  Really it's much more like
USB than I2C.

--Yb+qhiCg54lqZFXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzGPUAAoJEBus8iNuMP3dUMgP/i1KUksq0K6N+2VORV+rCsXD
5YjTFQJ4JPSm2Y+Ln/m9aRdo1MbxpRkp5qruGkt8Pv5yH7g5bmaAhCfAQi47xzQ6
eoxJ9C2ADI0rruRd5QwSFsdScgETmsrHp/gnJX6qJP0Oea6QOItdIvA0lBRIQ+Mg
c8JZuc301+Ub3Ih2jXMVQPU5U8nzukbOdUHHJS9dwpu90RbKCcSIMLvGTd6UfVc0
biJGA8uumN052OR44yLEBpUBsUwug623fr3gImUnYVE7O9v2GdMpRUa4qc0nbIxx
1RjC7StFSLqOyOub8FnDEL4EmIGVtFLof7YBXPUxOU23KYszVZcIVEuu3kgQdLa7
+Pqv4gbJs53ptVerTpgCFLxxRPJF6LZpbgJ4Q7Yomz862uYxfwicsFaPtbFpDZ/T
///nFDUpCcoAyM36rxDNnnYaGxNb0N96626w8J+arUHZlCZxKwySmMdxq9W3q4Nj
wC5mhmypLfhyyVQMc7MFBOwOGZDE+fHaNZyVn2cnkEzZLtlOF9tEtSw7jO+TruaN
yI3Y0V0usd86l9z1gMV/5MqKtETQRkiT3VZzBRIeF1CxnLltdTL7Uj1sz/IyHQP2
oocMhRTnxUbAZbdO8R1I5voWWMuN79lP03UoRjzmH5Eop32+IMml43SqrEW8AIF9
zF5Stq/oNFwbDBerqFiv
=6S9H
-----END PGP SIGNATURE-----

--Yb+qhiCg54lqZFXW--
