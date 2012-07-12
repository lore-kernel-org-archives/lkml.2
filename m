Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab2GLQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:16:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46484 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191Ab2GLQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:16:24 -0400
Date: Thu, 12 Jul 2012 17:16:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: Remove CONFIG_EXTCON_MODULE config to fix build
 break
Message-ID: <20120712161621.GB7256@opensource.wolfsonmicro.com>
References: <1342067547-6276-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <1342067547-6276-1-git-send-email-cw00.choi@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 12, 2012 at 01:32:27PM +0900, Chanwoo Choi wrote:
> This patch modify 'Kconfig' of EXTCON Subsystem to support either
> active or inactive of EXTCON Subsystem. The various subsystem refer
> to EXTCON subsystem for controlling external connector, so core class
> of EXTCON should be included in kernel image. If EXTCON subsystem is
> builded with MODULE, other subsystem have build break because of
> linking the core class of EXTCON.

By this logic very little in the kernel should be a module.  We usually
only force things to be built in if there's a technical need for it like
init ordering constraints.  Generally this is just a case of making sure
the Kconfig stuff is set up with appropriate dependencies.

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/vg4AAoJEBus8iNuMP3d1F4QAJUWy44w+YoGIXU3UEiQcq1D
eTYNTjuznrNLpz0UoK/X7HxTa443qDQ8MmQLV2u/W4iycxecqDNvz2aDaP9DZFKh
TzvK8l4+Z2QCsYiemnPBY6wet9fnV6QE6+MVqhn/Orqm/M2aawbhbGZeUvCmsDh2
6+VKNEIAvTE+F/t5sFqN/03G57iD5lo/VoWKl+w4c9UFpb1PDkJKLZtFWZ8IXu75
eRd+hWav7SgRhqeXojMPcaHx42T7AqEcyY5Ryg2Ff7yYMbrPplMzelTaH2/cz91G
AIvjLxBi5qW/gj131556aiIoVcPjuQOBru/WwGg3IoEUgei5tEShGyL2fBcUOa/V
KkA52kwIoXJLQP9pVLv1OtwpCiDmiJxjJCajFWXx9d3HKYWTEmH1qkXn+vvJK6uP
zlK/ROuVoR7d+AH7BdmUcQpAjBlbl14NO/R5n4l0KBzG6ljy3jmu8MiXPBV82uc9
4Da0HRfQ5k8ufuAlJ7or/nZE/DiHIwfwE1xMgjKMe8KNCZpNP7zrbfLtMrkUHma7
5i1H7EKwvuWyw02qutwq+SfO++FJZaPTx1wGsbHc6j3SiOIH/SmJIrEFV+/QNOEA
6ID2XjNcFWvIFvwcq0ITMCUHtl2YaUmlp04yNfeSiAfed7Co811HkdCNl+aPHdIt
vJhSRk1h+4GfUPCSp5zP
=cZVn
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
