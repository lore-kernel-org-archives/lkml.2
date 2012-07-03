Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2GCMgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:36:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58126 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280Ab2GCMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:36:40 -0400
Date: Tue, 3 Jul 2012 13:36:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: enable module build for lp872x driver
Message-ID: <20120703123638.GL29030@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FCCCF@DQHE02.ent.ti.com>
 <20120703093419.GB29030@opensource.wolfsonmicro.com>
 <A874F61F95741C4A9BA573A70FE3998FCD6E@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZiXfHLGvOGtDZMn"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FCD6E@DQHE02.ent.ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NZiXfHLGvOGtDZMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 11:58:43AM +0000, Kim, Milo wrote:

As I think I've mentioned before please fix your mailer to word wrap
within paragraphs.

> But this gpio function had been patched in the linux-next tree and now
> we can use it in the module.

No, we need the change to migrate into the regulator tree otherwise the
build will break in the regualtor tree.

--NZiXfHLGvOGtDZMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8udMAAoJEBus8iNuMP3dsR0P/RaQnQDiLPCKWvgwkXtYhWgL
8jRYEm53CoGvNji4PMUwvbENkmdR//5xrGg5ZDj90UKQijETg26+Rs9tPvcNkpyC
KqaS/ln5O2c5HVReZL8tnazs7gEDxnYFHsDmE3cCVzEyPn+q48+qAugmxKHkVNOJ
IK6q/QeAa2NXgtpI9+tm9O6NtVPsw/xeWj5Kd6XwdYgwv0Ho02ZaMEB23jY1DKvH
i2SHzo+fGIhBwnts37Np4/vKW/kuHZonlENTqenac6gIRlXG6hzJmYG3rY8ERNHZ
Hi5neV4pggLgSUkktSew0wUPRc/mmy0WY2TNr8qHCMpXDNSWTkeAdPYRzLyyHBIu
idxcwXeaCr+x0nLUu9E+b3hdAA6NEibcGCvGFgifNiMGJrGIE2NjqrTAPAgI6iMn
z8xSHVhfSkCJZ2NSEzNxc6FT2MgXSo6vMDN1vtHi0MlkhtGoSNWFNxmhJDNV3LUU
i+bLnt1WCK5ZxjjE9Ja3v8LWYSl5x69bXdMP400/+XHXcX+KO9m/iiaPsonwVF1Y
j2EXU7UWUm6fACKH7qjj7ThJuDG3CFt/SAziX+TxWdbIqwUWTjjdNeJ9NYk/s6c/
99f+Xb3gJFY+NtDb4NdrktfP/m8CW71IAtMgXC07DmaBGvJ5hG7neBbAa5eqb0aO
gWhjVwIYU+N6Q0UyL4hY
=TtZE
-----END PGP SIGNATURE-----

--NZiXfHLGvOGtDZMn--
