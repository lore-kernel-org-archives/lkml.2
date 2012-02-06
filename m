Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2BFQfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:35:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45842 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852Ab2BFQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:35:47 -0500
Date: Mon, 6 Feb 2012 16:35:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add I2C driver for Summit Microelectronics SMB347
 Battery Charger.
Message-ID: <20120206163544.GO3070@opensource.wolfsonmicro.com>
References: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
 <20120206160127.GF10173@sirena.org.uk>
 <20120206162409.4f7536cf@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BuBclajtnfx5hylj"
Content-Disposition: inline
In-Reply-To: <20120206162409.4f7536cf@pyramind.ukuu.org.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BuBclajtnfx5hylj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 06, 2012 at 04:24:09PM +0000, Alan Cox wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > There's quite a lot of read/modify/write cycles and...

> True but they are basically all in the setup side of things so I'm not
> sure the complexity is justified or appropriate ?

I'm not sure what complexity you mean?  If the interface is too
difficult to use we should fix that but I didn't notice anything in the
driver which should be more than a straight substitution (or deletion of
code in the case of the debugfs file).

--BuBclajtnfx5hylj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMAFXAAoJEBus8iNuMP3dxVMP+gLJfcDwjBJWoWxfsKjAjQQa
h7j60Y08DyQqPWB98WFZ3ggo7j1oKwI3oetG3yP1KyuzJ0yApENs3TBNY5qnhP0/
8rJ+n8zRxWk2UNwbgofplRNmPROtIfAb7U6+mumxaE9N1Fw+B6RpEy6+HRB8LLy/
OdCnkc49NA3pnKPXAPEdNTBrTNhN0AFG1dDIG8CNPHzNnzl4KrciuCoPpRk7GcnH
+e5CmNV+2tLC0jy/8rAXMS7SiUFr8nlKYDqIEjiQs7fjDH8AdzAFRGUoJHe/2+xA
MTsqRWCxwEy57c/nWMEOaCENrU476vN+RrfyblvyuwcavSAbvQH32ftJt6Ro0VOW
S7JRIni401GQnykPm3PcllODWzmN6NCNR0S9ameUunuLM86ClsbZbGfeeroDAsaZ
d498j4C8LwsRhcsLhmgojMPU3xO8Nf6eCf/qd62RvzhSTzo+g1qQhNmlWrUzKcCp
mQwiU/Jo9tEV05/+y7PLRYPPnUuUDTzcDBhMQgQ6Xn+EOOvX6PasGZVBhx2ktpWG
9RuQ/dYNtCoqI4tTHqHoEZISjp2UyoL0WF87UB1BXmt/lKb3FrAk99MnfZt2dsi/
EdX0N+nptGWwsYNoVMKz/wXCcNOfbBbBVY7FH7p/t5RGTOyp9cnYXD+OHU5MfJOt
H+g2D/EsE21JP/kmoL3Z
=ncAt
-----END PGP SIGNATURE-----

--BuBclajtnfx5hylj--
