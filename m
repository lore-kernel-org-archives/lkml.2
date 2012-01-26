Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2AZL1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:27:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45708 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab2AZL1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:27:20 -0500
Date: Thu, 26 Jan 2012 11:27:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
Message-ID: <20120126112707.GB9401@opensource.wolfsonmicro.com>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
 <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
 <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien>
 <20120126105331.GA8041@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201261221420.1851@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1201261221420.1851@localhost6.localdomain6>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2012 at 12:24:21PM +0100, Julia Lawall wrote:
> On Thu, 26 Jan 2012, Mark Brown wrote:

> >This is a really nice cleanup - I tried to apply it but unfortunately it
> >needs a rebase due to the change to use clk_prepare()/clk_unprepare()
> >which went in recently.  Could you rebase against current -next please?

> Could you tell me in more detail what the problem is?  I pulled
> linux-next and regenerated the patch, but got exactly the same thing
> as before.  I do see some calls to clk_prepare_enable in the code.

I tried to apply it with git am but even with -3 it wouldn't apply (-3
said it didn't know about the original blobs which was worrying),
looking at the logs the clk_prepare stuff seemed most likely to have
overlapped.  Perhaps your regeneration will be enough.

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPITh+AAoJEBus8iNuMP3dZFAP/ipSsF68uDxE0YiYLw/IZSLp
yUt/QjibSqz2nqPOu5whMFFCQY/MNe3l0gcPa+IpaUVZB/qBDGxfnh+GWZJR1IH4
KTOyG3OUA5NZVMpIRCJj5sY3fJ1J65nKBzNRnrCsFrLAErwZOeJLUywEj+TzprZp
jT3nxEmkfJ7xupbYJmXzpJ6yf+G1Po+4hBWcph/VwJGgchzxCrsmidfczkJes7D+
PZtlTaLO5GMahTzaGoLGtRBJ92IEZerGg3+8LkdZlHdePP9qH9ANna4DGSecs0kz
VfMyqpHAqOmsutpHt6WKHOHZEyd0G+XOb6F0YWDLlmlC7MyMEGAIc/vLXyJHq4fB
2gWfZAYDkYDFcmo2iFgVMCBAEH4caugf8et5UQWEL4ENeye47e8qlBWMkAKZXMpw
RCKXBq/5iFeXgaamN3LlSv7elwUzNcis54guEjFTJWttWGxHi6qkTer5oIPJURHa
uojHhONW/IKd/ob5nPdHNR7i1gRNc2oKdXDj0tMWq3B+RB+/zeM3lws9P33UIk4H
JnmQie80bPQgKjCuMDd0Z7HoWhQEwklQZmj5JNt8KHLSQIER9Y2zbf2Bx5Pl/4ou
5U8J3lH1X86xScVBMExq8UcwHEsHlzhXpZCs45h3d1wHu/qIhYy5vy7MifN33mKr
8mzbPVTHsTIdVqq0ZFYi
=EhiZ
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
