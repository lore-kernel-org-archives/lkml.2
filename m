Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2EaN1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:27:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57174 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758102Ab2EaN1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:27:47 -0400
Date: Thu, 31 May 2012 14:27:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 1/2] regmap: Reorganise regmap internal read/write
 functions.
Message-ID: <20120531132714.GG2666@opensource.wolfsonmicro.com>
References: <201205311316.q4VDGj8d013771@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQbNiKLmgenwUfTN"
Content-Disposition: inline
In-Reply-To: <201205311316.q4VDGj8d013771@sw-eng-lt-dc-vm2>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yQbNiKLmgenwUfTN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 02:20:42PM +0200, Krystian Garbaciak wrote:
> Separate caching and bus access.
> Make functions reentrant.

One change per commit, and please provide clearer changelogs.

--yQbNiKLmgenwUfTN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx3F/AAoJEBus8iNuMP3dJMgP/R0DoAqvlnDDN3iWXpNkrEIL
d3lwtzhKOBmn0nHm11ZowGCMVncbqFii7nwBl1W60Iib2ELYfFRbrUiTeigRggBW
jYlVkjSnRKeMUFcd4LgSkzFWQSisobZIl2XsnCQ2fTiMND+v26OMp9nIVFd0E7LM
hMwnce79b5B9ntM5AU8PSIvBpVPBzym+2Src/Tn2PHaPeeHI8SYl0Viacpk1DSwP
Y0SAuWv4OJDf2o5ry4tEVnyTUR1ZvIiQBEpnkhf2a1ONO61lWdF/v9iFx14ZL73C
MVrVR6Y4JvI6qNZHdNZh4HSPA++y4Qtg4jHl6bK6g1UgrIedNP/y338EucjcDR1F
2i/zWRV5MUZ+VLXNs9VAYNb+4NiK3XNn0lETEdFpfcdtbZnKmCChzd/5QLoJ4L/x
MmZ6mWpqrP5jiXcbUZF+boCQEMIhSJJz3ImpsgXWsRLiMddZUMp/O/BUQLfQnBqa
3UcMukET2qjNdSYmkUbA+Sg6x/fIUy2DgN26lhIeZcpgtJMlEboGGObE3PRSMTvU
kHSCAe4m8jguI3REwCGsMNfe51idCAAL/5bJq4LNOeMgd92Vfa22gerTB9xxmgHP
B+9AHCnJWQAdlx2eS8KJZgnLmu+xrilVXdgeJY1Bq8mvwBIPs7Q+xkEA7HIHCz8c
iwNSica7kjGDQZdhcCCU
=7MaN
-----END PGP SIGNATURE-----

--yQbNiKLmgenwUfTN--
