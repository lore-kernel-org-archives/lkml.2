Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800Ab2CMXS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:18:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48495 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414Ab2CMXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:18:57 -0400
Date: Tue, 13 Mar 2012 23:18:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max8925: Use DIV_ROUND_UP in
 max8925_set_dvm_voltage
Message-ID: <20120313231851.GU3177@opensource.wolfsonmicro.com>
References: <1331625781.3932.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2wYUONsACSj9OMJp"
Content-Disposition: inline
In-Reply-To: <1331625781.3932.3.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2wYUONsACSj9OMJp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 04:03:01PM +0800, Axel Lin wrote:
> Use DIV_ROUND_UP macro for better readability.

Applied, thanks.

--2wYUONsACSj9OMJp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9XLAAoJEBus8iNuMP3dvEEQAId81normpm3n/B1ER08Nm1b
XLFoawTmvheemN7L+5A4718j9Tk/jkAAyWtGCUHgLyRW8lt6ucP4elohIgbFQ2oP
MZ9G9lkNWeFsz2M0RmFEZthGAVAgvx89xqbzP3ONsUyCWDK7EMz1fX9bROF5heKn
CNeFFfjnWBujmQhWutzmxPUMijknLYieOmNpR0DBqETg2o+p5NRXectyL0Cn/dgy
unS92OqlYimwA7hox/M3mu7arVHPETuylneVUfsuVOkmXo/pu9LqUyDQ+OBtWFIY
MVrswFzMcy3xH0tN7Th4A4PKfq0oiiUn7EbJPmEMCbGqUA7y+d4+di7dzdqq0ub9
8CxrYFyxweuR0FwhU1fOCv0IwRDsiZV0g4g7Z0/4Ob1V7FV/Aw8uYyLQkSbT9kj+
jZt/IUB1ygH+8p0rfGOmhULpvIBk6Bc2XQpbx7P4gOiRL4/ey2VnU3G3ncdHfU0Z
8Is4F5fIAmj1lE8CY02eMkN94mdPnq7tZhDo1AXTOuu6sdL8bAo79S/vx24MjJom
Ln4wtVpesUTvAzJu70kXhjliIeRNnV5JBGMhtjdpHDMTurDWQJwwDnHG5BHJIOzK
5hVcEKkHYSq69velaXDp61crZk0SW9OjytWxvPJDelAT+CM4lyzDaBLc3bRoqtIK
wLh/UtIweXJbTP9W3TNj
=DlqO
-----END PGP SIGNATURE-----

--2wYUONsACSj9OMJp--
