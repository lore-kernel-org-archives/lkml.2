Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2CUIyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:54:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36593 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab2CUIyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:54:07 -0400
Date: Wed, 21 Mar 2012 08:54:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] regulator: max8952: Simplify the logic to get vid[0|1]
 status
Message-ID: <20120321085405.GB10935@opensource.wolfsonmicro.com>
References: <1331772468.2981.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <1331772468.2981.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 08:47:48AM +0800, Axel Lin wrote:
> The syntax "(((vid >> 1) % 2) == 1)" is inefficient and also hard to read.
> Use bitwidse AND operator instead.

Applied, thanks.

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaZcGAAoJEBus8iNuMP3d5tcP/RXe9tNNUPIIPWizzrAVZy8I
uKOPGoNyppxX4z50buofKusBliNR5hO940O146zBCBBrzh3PWt69jmd82jhcL82u
N6z4tQODvL1eYzScFWuAbnJ+G9JSSvUE97SPw2v2th/SKD0l4KsjZ+PvxdY2ae1O
ismVdcHT/4FS3D22+egvvepwpKOITAseFYQP5K5qTNKEOKyiMirFD5vtxsuBzVKY
O1YW1ndxoR1DoaRQO3xAIiglcKpBNRjDAqPIcNDTyk3tMZvivu0c8utQecmhz/qJ
gIj0xbeCkwCSifctwhRkvpQEDpBEwnbG2pAhdl3cWgkhuBQLBsZhs+29hk8tNpRL
qAE7R5/lZAeSjppNJw4bTLoyFAFAr2NsmOg2AJLupOF5PLsUETuotQNKCzTF/laJ
QplLdXHD843B9h4vLdab0RYcm6mqweCzdHMW0fcWAXFYw8FNm81l/vJmnBglzq3m
qdh847obdvC5krKL6pOIrfsAXNu/+rWxBSiWBzMI0i6hKIdQvr3y5LvS5lexrRS9
SWR2gZectEGgj6g+AkGsp7m/Qe6SdieKc5sI9ileW443FIHn44LL62RmLCsKuYGH
BZn+3BlIcxI8+44do1grBZ4o8ROEV1MYxuDovuFV9kBU4xrJK+OyU3Rt/AkT9zvv
Eag1Vuy4X3Gtts0pTnGW
=Ybra
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
