Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2C1PvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:51:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38263 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab2C1PvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:51:09 -0400
Date: Wed, 28 Mar 2012 16:51:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        Fabio Estevam <festevam@gmail.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        paul.gortmaker@windriver.com, dan.j.williams@intel.com,
        samuel@sortiz.org, lrg@ti.com, perex@perex.cz,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, fabio.estevam@freescale.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH linux-next] dmaengine: add context parameter fixups
Message-ID: <20120328155106.GY3232@opensource.wolfsonmicro.com>
References: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
 <CAOMZO5B-Zutv-xwqLCAgNMO8A3Kyg4uWqS41koo-yoS4mGB1TQ@mail.gmail.com>
 <1332740082.19804.15.camel@vkoul-udesk3>
 <20120326094200.GA3098@opensource.wolfsonmicro.com>
 <s5hwr64wx0p.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t4k3FX2BKM3OLyzG"
Content-Disposition: inline
In-Reply-To: <s5hwr64wx0p.wl%tiwai@suse.de>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t4k3FX2BKM3OLyzG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 05:44:22PM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> > No, not yet - it was only sent after the merge window.  Quite why nobody
> > managed to notice it before then I don't know.  It'll go to him soon, or
> > at least to Takashi, but don't know if it'll make -rc1 or not.

> How is the situation now?

> FYI, I'm going to send a pull request to Linus tomorrow or on Friday.
> If anything needed to be merged in rc1, it must be there in time.

It's in my tree, I didn't see an enormous rush to get it in TBH.

--t4k3FX2BKM3OLyzG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPczNCAAoJEBus8iNuMP3dq1kP/2fx+sTM6QZ1T8IcQRd+8HtY
c5GajFfOH+nOH2IPD2pd4Bn0Z4povKjxq6Lss6AaHS9ePs2JCYLCwR7+5InBHelr
eu3hrkSFnXnGmlQrhi84FN0zgpn0+Sbu70W0gLCAIzbmubMLpQR8J2ZRrh2pYZgl
Ou2K+Gmt0On5bijnwiOlpWGN5Vie0VmA9eTjuSay5Ohb58Rg/suxrRztmTeuX8aU
9D5AOxAbwag/5CKB2xbmln2lupHn/EyNqTM9FKrSnsHvR2NYIw61ZxAF/izCDakD
CMIMQNsV7tGShjmI9tG2XCJw/39xw0wcUf7D22Bq09lObiEf+NOHJ4ex+91tKwP5
xx69Ub9zMDjt8Q/2h433mUVbId4nQupd7uZX1/VH4iWAnlxtsHdPsdwSFZjVSp+l
psTfKMurryiNe3VhGx1nWlNv4gofiGWRJcAvQfFgJ1pqJcTUQPIePlBv1ol17Hws
GIHF80Mj7BvLLjFerGqS7gvozAC+Z07pDUChR0ttr95cXETfO22rcpCWX20rnA8O
5RMXghGRGPC5OvW4QHWalZoybbipSyxRzVF6K9EAJN8dKi4xBw3TtCewHo9q7Yau
KyccnxcvME5DgZoeNdE4DTdyHxojY3cJbaMUxKTxvRCs4KfCErOXaoIl45hWcp4Y
sKi4RpCEhAkCpKyRtT3j
=DSFu
-----END PGP SIGNATURE-----

--t4k3FX2BKM3OLyzG--
