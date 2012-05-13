Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2EMSR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:17:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33104 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072Ab2EMSRZ (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Sun, 13 May 2012 14:17:25 -0400
Date: Sun, 13 May 2012 19:17:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Dajun Chen <dchen@diasemi.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: da9052: Fix genirq abuse
Message-ID: <20120513181702.GA31985@opensource.wolfsonmicro.com>
References: <1336932282-31898-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <1336932282-31898-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 13, 2012 at 07:04:42PM +0100, Mark Brown wrote:
> Rather than using the pointer passed back by the regmap API (or complaining
> because that wasn't actually being set) the da9052 driver was having some
> fun and games peering through genirq and regmap internals. Fix the driver
> to use the API as expected.

Sorry, I also meant to say that since this fix seems fairly obvious and
blocks some other regmap work I've gone ahead and dropped this into my
regmap tree immediately at

   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git topic/irq

Hopefully this should be OK - please let me know if there's any issue.

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPr/prAAoJEBus8iNuMP3d90IP/RBBuNyvPnxkHsw9bSrmk5wZ
ZzrCYCnpRIpTRXUVmZHJwgPnK2fKpwxUkGZeHQ2h2LiHZkNslLaRVgYfQQgIzQ5c
YuUGQFc7HiCV0zqUl+WRVnE7GdDDWyUyoAiZia8MehCuJe5UEwcGQCqm97w6r5D4
2Omz8YKLXVudf0hYHSRwyCVUvLbET9A2D3MHtabraNdkkdNZhkysXI91IbmDvQyb
t6v9rr2w3JA8X6yoyxDcw/1VwEYwCqYLZsAYMcdbCwlMyNM94cR1XvwqiNRCAig0
3g75tNEkeQ+MVTOgkapZEa/BW+nDORf3v8AlVcUmqbi6VUcg+e+9rRFNEW4ISDeA
jB8Cwyw/NmeGwd04doQup+6rXo1Pxt894rfORKYi8mLcD9WecPs0FsVMdc1lX1bj
vDof4kSQauh560bd3YzHWF82+ACtLd7myF20qny21iO5f+BpG7yWcDtcT9TjvC7I
hRf3nfdmIwUcMgEL8Yani4sVvxFpPi6vfkeeYbpDqgqdChErgOPAjrHVdzyKlNBA
Hu0vjVAV6fRe3sj5zgI2j6DjpgjmsdlHKyXwQBHPvN6lSYla38baI8h8SYXItWtF
+ro9h+0hGmGEWPdH6U0uFd1r7NIGOxkQ6tr78L8dHJeLm7k+rH9sU0joougaHcNI
2bDzZ48Qw/C5Fn19S1e6
=u1fH
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
