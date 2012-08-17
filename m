Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2HQXEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:04:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44954 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756022Ab2HQXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:04:30 -0400
Date: Sat, 18 Aug 2012 00:04:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbou@mail.ru>, linux-tegra@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120817230426.GC21888@opensource.wolfsonmicro.com>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <502D3E29.1010501@wwwdotorg.org>
 <502D61C6.5050101@firmworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <502D61C6.5050101@firmworks.com>
X-Cookie: There was a phone call for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 16, 2012 at 11:10:30AM -1000, Mitch Bradley wrote:
> On 8/16/2012 8:38 AM, Stephen Warren wrote:

> > Device tree bindings shouldn't reference Linux documentation; the
> > bindings are supposed to be OS-agnostic.

> While it is true that bindings should try to be OS-agnostic, there is
> the practical matter of where to put documentation so that it is widely
> accessible.  The Linux source tree is one of the most accessible things
> there is, considering how widely it is replicated.

> As the original instigator of the policy that the device tree should
> describe the hardware "OS-neutrally", I personally don't have a problem
> with bindings referring to Linux documentation.  I wouldn't like
> references to proprietary and inaccessible documentation.

OS agnosticness isn't the only issue here - the other problem with using
Linux documentation is that except for things that are specifically
userspace interfaces and the DT bindings nothing is intended to be
stable so bindings defined in terms of Linux documentation may randomly
change.  We're not doing an awesome job of that with DT right now but we
should try and so we ought to avoid including non-ABI things in ABIs
like this.

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQLs3zAAoJEFJkBDiqVpZ4NucQAJowkgvCBihoqNrplgWBVFgj
eps2rAS3cFRH8aUzgqi31UuAvyHmxxnI1+BoT4k256E86vC+b6asdeSov3iUGTKZ
zZ6JKvaNIhkWaFYDKsciztyFbrF+26Eq2qRgLImM2vy0Z/yjayQGrI1DVJ3z9B00
3WIaAwC7Q8SNc6Ilwnw1jOGWMGWe+2Gp8Z+BOXt3bsmqeESoQvaxP2tedU2/NYgX
WdYbOy/eP5lC46/R35yuGvRSeCs0AU3/Ii0psRzn7eVlCwViqSBl2ST7H8rGa1Qx
Vn94ZyWN6gVgBjadQqX6B35By05uhl/fyKA01kX1CL5JQowD0tjno+E9Ai8objER
JuWzBH7IPKxY+p47Ak5sGhB2yrFdtJCNEQv8lnAoRLPM0C9X9D5vwmQkc1hNMSr4
rDdiZ8xowXEfAnOcMBVryWrQcaUvpW2rvshTxuVvWamn9Mg1F4PD1m0X/nzcprv4
hYgtOu3oF7M7rj1RpFdKdZRX7+J3HvmtRdB58E1mNJrqcGag0YhjNtBu7CFrRsrd
dm1V8vjqKiEufh80lpvIZ+ipWcG6JAGplrL/vEwd0prv8beHGM6RUH6wMOngsVe0
r6gZFkmTnJP5at09+4Yep99RNpFn6dPjN+ijWmAYrCqVn3JmKJK+lUnQTk/i2D12
7Ivne2SQwes7v1TvJeQg
=V2+Q
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
