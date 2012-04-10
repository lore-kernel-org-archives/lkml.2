Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab2DJIfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:35:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45407 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab2DJIfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:35:47 -0400
Date: Tue, 10 Apr 2012 09:35:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120410083543.GC3149@opensource.wolfsonmicro.com>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120406074942.GO7264@S2101-09.ap.freescale.net>
 <20120410083130.GK24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <20120410083130.GK24211@n2100.arm.linux.org.uk>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 09:31:30AM +0100, Russell King - ARM Linux wrote:
> On Fri, Apr 06, 2012 at 03:49:45PM +0800, Shawn Guo wrote:
> > I believe this patch fixes the amba probe failure that impacts any
> > AMBA platform build with CONFIG_REGULATOR enabled.  Could you consider
> > to send the fix for -rc soon?

> No idea.  I don't have Mark's patch in the patch system.

It's there as far as I can tell - it's 7366/1, which is visible in the
web interface at:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7366/1

Is there something else I need to do?

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPg/DYAAoJEBus8iNuMP3dCEAQAJjG3BtROC35/BAxtjp8usEl
vAxPFg/TXDZ4X2JxwzN+GSXW6oWL29vDfaU77pMI8zITfeFzRj52UlWLw60WMttM
BqKr89IQppiV/jm8099YKx1duFBsz7XRektApHPqsi3JM/lx+wlLTgYffIE187Vd
pQDPGKmg6f50qMJQWShEqTOQDerVXf9ShNif1O8txPHZCc6OUzUXv/+2fUDoIh0m
SkwJUKRBlDaZ60Tqx6GcH1ugNnMLXFHnFr6w5HY/K8nRlrl3PVUrhIdx0Invsjzx
zK2ErfufDIXrSUq6nheY3H1A/euoVcvURL6wLsghkh862FSn7lm4MNh9NaqMgK/i
8cDbe/f3OJzVSkSbvNyGhMk8c3eYQ1iQw0NVJZDz8vCU405ugLgvi0gbWwOGo4GN
dj9HZHA6jdqTn8saKze8YBKjl14Qg41vj8a6GXtG0rNdDUpCW7pjXwq9P694ouY4
+q4e0C8XW956NfXVnepla8dEcBTvBVCv3SeixBcKPjWpgDTMsy02vUeVAfO4K15m
sfwKw2uX4d01rpGMDqDrOyNUhJbzAob+zcP607o1uuklBvORCUO6y9+McZHRoosA
sCI5qP3SsYjGXo9gB7T66qQDyirjfE8J5a8buFMTHsl9ijgfrm9SOruxqjxfXg4O
/UBzT2gMov9IcxvHYbV/
=Y25J
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
