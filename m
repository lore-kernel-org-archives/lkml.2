Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2CXAx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 20:53:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55661 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab2CXAxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 20:53:24 -0400
Date: Sat, 24 Mar 2012 00:53:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: paul.gortmaker@windriver.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, samuel@sortiz.org, lrg@ti.com,
        perex@perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        fabio.estevam@freescale.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH linux-next] dmaengine: add context parameter fixups
Message-ID: <20120324005320.GB3190@opensource.wolfsonmicro.com>
References: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 23, 2012 at 10:00:42AM -0400, Alexandre Bounine wrote:
> This patch fixes drivers that use device_prep_slave_sg() and
> device_prep_dma_cyclic() interfaces and have been missed during the initial
> release of interface changing patches.

Can you please send a separate patch for the ASoC (sound/soc) bits of
this?

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPbRr2AAoJEBus8iNuMP3d4BcP/RpL0AxKVsJNqh9SMqEmiC+1
TL67nLDRzfaSIVHHB5Yop94htNAw04YcjtEbkH6e5CbA05nCl1tCsOiQSbjtaqXY
9qiKYCz3CA7YP7uv4KanMYI+2hSGlmgsRBJbr0Q7BGXb8mO2hX/qbh5lYf+RQInr
/RFQsH5f/eV7HXdDJeKyZtYaaU8XB6oCQ/CgOj6rGcb9Qm2f4Di6eH8ugD7/aPxV
dYqMuBwxGbDJHd+B1CoNQOzwEChemHzcP1Bwfj/dTdbiyqmhLUtTsjFV8ukb03uH
czahRelRMBEn+MSua78dOpR+KlVCO8kQiiPSYcXyu/jvEIk7JvmoYCJM99HxwYqq
kKhoLvitK7buq6saku/GfRIZP++GFlvvXhl/i5bHIjy/xmHRXLE+87IIqt1FtiVm
sq1OPT+p0qKvYFGRzEBwHPfE0Sr90TLk79unzx1ec3pLGGMZHwVX8OzbhkJ0wQ4J
c0UHS2Z0QcMcASmQ5yjJmfV7ZmT7d8KfyfZkB1AxGynZs4YO7Gf6ek9+g/CQV+wf
AiiDsPzo8WQbc0yphfC5lQLRIb9XqO9xwTQStOAcJcelahOrP+JgI/c89/HlXjSw
mru6IHCa6rsqOF8UHGXs3ty876dfYwG/IjqB5Xui5Hg4eITIeQmgPYHpH37VVwPp
27z2KTXSictKNvlinuLY
=4ghL
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
