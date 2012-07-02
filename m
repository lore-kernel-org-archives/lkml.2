Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2GBQrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:47:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38275 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab2GBQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:47:20 -0400
Date: Mon, 2 Jul 2012 17:47:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, "tiwai@suse.de" <tiwai@suse.de>,
        "perex@perex.cz" <perex@perex.cz>, Stephen Warren <swarren@nvidia.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
Message-ID: <20120702164717.GH25093@opensource.wolfsonmicro.com>
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com>
 <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
 <4FEDDF89.1050907@wwwdotorg.org>
 <4FEF166D.2010705@nvidia.com>
 <4FF15B16.9020903@nvidia.com>
 <4FF1D00D.6040402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtJ+CqYNzKB4ukR4"
Content-Disposition: inline
In-Reply-To: <4FF1D00D.6040402@wwwdotorg.org>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtJ+CqYNzKB4ukR4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 10:45:01AM -0600, Stephen Warren wrote:

> to work. No audio is heard, and aplay eventually exits with the
> following error message:

For values of eventually that will be about 10s by default.

> aplay: pcm_write:1603: write error: Input/output error

> I believe this means that the DMA simply isn't operating.

Yes, normally.

--vtJ+CqYNzKB4ukR4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8dBLAAoJEBus8iNuMP3dGtYQAIQ4oi3fWx2/1CpS22nbIE5B
uddwrTiyOG/9Pq2o5qZL4kaiftEBXE2Ms6dS6B4nJeDDEErNf4V0cqxEbkh1IXCc
h6DSh6BErtqyxewJjXihc82Bkj+9nx/DqeXiFDniJXgw2uXzAeCnUO8cywLt/bSh
tNRz8De3l7GK2SoR2+mXkmHJRKBRV9wTGLBKHE/VKRJWM6Yd4MxqjfwrEW6g1v5H
/nHvvQ/LiA0nKLx1UtnW81s+ylqNjmmFBDEPwMlGqtXTX8nn440PoZwGveYFTU+B
KkPqUCupdXdyw3BXXVJLUXR6/umhRC3qtxUqaeKXXoJLiIBwyNbVExx5wwcvkK4I
9BJ6NrxWps2Quwbb4zsVBh2lDsZbsmBra7yqk79pTogfuXg9YR1hqYvNJRrfQz+w
NbQrrBGNOL+aZLJlDULpHP7czaKEQMmKbySrzB4ClH1+DWR0Q04RyXFcaaM0Z7WQ
IWGK4sYIvPedy9ag4mpkl9XqMV/TYKXLrus2goEj+Tc9mGcf26Mks+64HRVH5MNx
7q/CB4eDHcFB0E0hbGWOUeSht5hKKVotop0dS+jyuz7b4cUMr8xKJaa4Gx6+9TXI
WqqU/DVIyJZlwOVfjgXzXaqYtcpddAG0NtFM9CDXlKlCzLmK+Ve0X5sBQKcu1LHj
rttdcH7OmW6g7CVJVLw2
=jr6N
-----END PGP SIGNATURE-----

--vtJ+CqYNzKB4ukR4--
