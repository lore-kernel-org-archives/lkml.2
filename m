Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2BHLZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:25:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54053 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750Ab2BHLZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:25:10 -0500
Date: Wed, 8 Feb 2012 11:25:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the sound-asoc tree
Message-ID: <20120208112507.GD3120@opensource.wolfsonmicro.com>
References: <20120203125902.558e273c84b339957869f281@canb.auug.org.au>
 <20120203105123.GB3151@opensource.wolfsonmicro.com>
 <20120208105228.a3b2ceeaba1a63e5df9dfbbc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Content-Disposition: inline
In-Reply-To: <20120208105228.a3b2ceeaba1a63e5df9dfbbc@canb.auug.org.au>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2012 at 10:52:28AM +1100, Stephen Rothwell wrote:

> So, you have redone the merge (it was commit 05960268bcef and is now
> 6127dd802637) and still left the conflict tags in
> sound/soc/codecs/wm5100.c ...

*sigh*  This is why I don't like artificially split development.  Should
be fixed now.

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMluKAAoJEBus8iNuMP3dMkUQAIYTn1xnMGitPfbpfCSaRcXx
ha7cwzHlaarLw5NB61pxjG3mqp067KNwGQBBg7/fyeSxvYlzrGxkTvanh3yjjFdE
dDTIosW8R7IHhTz8BkAMFAlRzBh0znUfClFtNhoxGW24OG1+UuEPiQ3x1T+99KEr
lzyuomcRw/Sl0aNyGOkzq4oO3R2b4ueh/9dXPS/gyVECHmZBlJElX5AWGAK+9OL6
LNXXL9e58Qaoa8oDcEApqHduTTGPVPmwrlkRW+6npxVMENoT2sCcprjKDX3IF5I4
FffuiagGY5gSmZRFK4o4UzNEy/LVH6JxARbg/2OKiJuU4FY7CD8nxXPieKp3X1PT
acLNq8sLbGZ2cSWz19ytonD9BWCwUUSEZZHWFWp8XqcbZ2YV2zhjfBytaV8NBaOo
56h7cr5sXjBT6/KlHm5Q0g8oXF3Yfi6F6v6aejqGaZRjBQcerGjAshvAccPxotcu
d2ZDtgJHrDKI5nvdzk/NGPDSVsNp3JJ87i1dJPtRtDjB49JbqeEwU916PskPaNJE
00k6vDUKZM+oyCwfAC7cApdwqqld2DCrZdqiEv8Q5oQiLJbqerUv52MMhw36B+pV
euyfAyVepJIVCkMS1KYytWKcVaVblsxv1EoKigEvfDalswmo4h6u1/KaJTx0sWXl
awkSNFGFX3CihHanWTUy
=Ya5p
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
