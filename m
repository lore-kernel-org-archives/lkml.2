Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525Ab2EPHx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:53:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52760 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965132Ab2EPHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:53:26 -0400
Date: Wed, 16 May 2012 08:53:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120516075322.GA6801@opensource.wolfsonmicro.com>
References: <1337004985-22549-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAJOA=zMRRJB5HZhQPNBbAc0+U=Rgs9v0feDqK-6VRUzGnUEbyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <CAJOA=zMRRJB5HZhQPNBbAc0+U=Rgs9v0feDqK-6VRUzGnUEbyA@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 15, 2012 at 10:00:51PM -0700, Turquette, Mike wrote:
> On Mon, May 14, 2012 at 7:16 AM, Mark Brown
> > The WM831x and WM832x series of PMICs contain a flexible clocking
> > subsystem intended to provide always on and system core clocks. =A0It
> > features:

> Do you plan to rebase against my clk-next branch?  I've pushed your
> clk_unregister patch there.

I guess; I had removed the unregistration from the driver partly to
split out the unregistration so the driver could get merged separately.

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPs1wfAAoJEBus8iNuMP3dOnEP/16XXjJXyasOWcIEP+LgKLUU
8VVGGufUOIL2GaSQu9gFLnEWMvl5YE95KeY/31rwtid+Nc/7AOgTtYAxsEpqtiaL
+7Bw8X681ci7mlEpG7tfEsyrzNXPyeqtFNby9CJ9Q2sBJgspPj1FI7v+3I6sXfC1
dxMTG+Zkm4qePdrQvXw12+imkQvyfZJ96YzOEu6oU3MRL2Vchs3etcVUt1xYm8KF
ImnoSmEat/g+VqNP+K2S3sPWQfDC1iYT5HEyhEzon/3XcLoz/yn2yA4la26tE0ja
CYxojPJhfIypCMcw1wotUKxLIGSbkvSiWt47Okcn3ze7gkjOzV/KBuqsvCKn1vRb
1MCe9pAMfmT/Q2kQpRlwZpko60YAKSMYSQsFmmJXB/IDpYoJlXUd4GxekPe8Y4FN
IYe7KISmVXfbVDdVwLyaz+V/Gq6Mye/+KUQnnrII3SmeuHdOt9ahm+ss45/ZZg8Z
pYOVebaTxgVDfvuCtxKWEVl0U50y7SYz3wNo8crvkyePiUJrfmRIQ40s0gCNzGiz
iSGF5eoD1QI21iTTeNNgjQoU1axHN3DDPQt29SbiFGnEFlzIBkomTzTnmLYPD9vd
R8hw4Ot6HpmrJvWEm2t9HNnmS1NCSfcWjm/bRt2ioOwm7iRHgz9ORFgY8yd+hQdJ
DbeGaDIS6m3IcI4dtnoa
=d5vg
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
