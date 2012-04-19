Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2DSMup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:50:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826Ab2DSMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:50:43 -0400
Date: Thu, 19 Apr 2012 13:50:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/4] mfd: tps65910: Add device-tree support
Message-ID: <20120419125041.GH3046@opensource.wolfsonmicro.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
 <1334710829-22777-4-git-send-email-rklein@nvidia.com>
 <20120418090133.GC3021@opensource.wolfsonmicro.com>
 <1334777758.32315.37.camel@rklein-linux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
Content-Disposition: inline
In-Reply-To: <1334777758.32315.37.camel@rklein-linux>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 18, 2012 at 12:35:58PM -0700, Rhyland Klein wrote:
> On Wed, 2012-04-18 at 02:01 -0700, Mark Brown wrote:

> > This is a really odd idiom - normally the pattern for device tree
> > support is to just go and try to use the device tree data if it's there
> > and there's no need for any flag to say if it should be used.

> I agree its odd. My concern was that the idiom is that is pdata assigned
> from board files should override dt data. At this point, we don't know
> where the tps65910->board_data is coming from, dt or board files.
> Arbitrarily using dt breaks that idiom. We could do a check like this if
> you prefer:

No, just prefer the DT - what you're proposing is exactly the opposite
idiom to what all the other DT drivers do so we'd need to go round
changing the policy globally at which point we probably want to start
having helpers for this.

--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkAobAAoJEBus8iNuMP3d0G8P/1ZuDSlYEuJ/Q6btReoR12ax
Gzqe8XbLjiifIRKNHdO1Ozo3tw6wcvijajygtop4RXyj11Syp6hW4n/l5/thewDl
Pnnm14qyr6HgNHNNcE2XNbB47ze/YeQXa+4E5q7UkjdnOQOWzlW90GxA3OXz+Sxx
hFUJxiplGFV8RvXTdr1qU61a1bqD31dTTG+S6foSCSypAmAoFDEvphmL4KvHAZ3R
GZeMgoV4AF5NhshR+2ECKyxcWlrCCdpX9VBbzLiCLqi5IZHoZY0FeBne2NuhpzyP
E31pFIa7k+I4E2+Knt0TJprepZocTYLSK5B7klZML5Ro+1KOQXGAKP4YtEk9pbjM
0M2ADOCwNHf8MsJWL9wfUkRP+TerWrO+Hq8f72HqZTIGJxlnsi+3vYdBGGdjO/wT
nyWiePobKP4twUjeK4++WCtsCj2nmuzZ5kIwRFw51h137MM7TTmmSb1n0kKgIO94
dPN4KLatXqw9eJoelstTMxJvRPHechn5vHvmvXK+9gifE6zCeJfUYhwMEinkgtQR
CJLwFuPS6WyzuhK4vdejhH6Q8LaWBlYyhaKvniFOAWa3JlDtnMol2sakSCjBf+Vi
7M0Yhn3aJ1gtaWTe6vG3D52xwkZTI6IVOWuIY4Q7oPOeHnMQpbvoqhff4vFn/TYe
J6Kd5fqYCZf/hFpYFMTT
=Npj9
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
