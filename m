Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2FIDGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 23:06:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45585 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2FIDGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 23:06:49 -0400
Date: Sat, 9 Jun 2012 11:06:14 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, "olof@lixom.net" <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Message-ID: <20120609030608.GF3924@opensource.wolfsonmicro.com>
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com>
 <1337691917-15040-2-git-send-email-ldewangan@nvidia.com>
 <4FBBC192.7030900@wwwdotorg.org>
 <4FBBC830.2060802@nvidia.com>
 <4FBBCA8F.3050903@wwwdotorg.org>
 <4FBBD33C.8020802@nvidia.com>
 <4FBBDA97.6000006@wwwdotorg.org>
 <4FBBDE06.5080806@nvidia.com>
 <4FC916AC.4060804@wwwdotorg.org>
 <4FD250DB.2090207@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/NRh952CO+2tg14"
Content-Disposition: inline
In-Reply-To: <4FD250DB.2090207@nvidia.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator
 tps65911
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K/NRh952CO+2tg14
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 09, 2012 at 12:52:03AM +0530, Laxman Dewangan wrote:

> So is it fine to go on the above binding?
> In this case we need to find the match_regulator based on
> regulator-id rather than by name.

I guess.  I'm not enthusiastic about it (some way of using the key/value
nature of DT as a hash would be much nicer) but it seems that the
combination of DT and the existing code for it can't really give us
more. =20

If we're going to do this we need to update all the existing DT bindings
for drivers that use single node regulators like this.  Please also
change the name used for the property to regulator-compatible to make it
clear that the idea is the same as normal compatible properties.

--K/NRh952CO+2tg14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0r1hAAoJEBus8iNuMP3d7PkP/i/9CIfw24hvnllnVp7yoJ/i
rSwcQSPpH6PfwoeBhecyhT60dkPs2qthyLMoqPILiqVAmuL/Rejki+90gmS6ggDP
XGxmGWQI7rsfNwhalJQEYTc0GDOwcF1Zrqty+KbAMsjaz7Ls5tBBbcBdYf09NBCX
pzNDpmqqzMhMoTL7csXcHZgPuC6oe64WGyjd8wtKmBPsdoyyGyuLiS3qyg1AyGnQ
R1IRqoIJHD1kAWWrE9K1EEQpC6kbVBeD0PeDlm+w+3XSM17btgpUsl1eGiFM+dqT
3Vcw6PvZY4qorq+Ti4PXz1NMXvMBql0khHQHbJxypxqPiB9ZQffG8cjtDSm2uKnR
ub7ZkXtZvRKNfYcLgCZshWHrkHvetqmOcwHTlIXkM4sjF4jzP51d7GDr3wCDVE2O
7yipboBnHm3lsut43K/reXByx5ylwce0SqHcUzrxBO/WvYmkkZbxYe8Oltf84mcA
6Ji6p00bQVYG4716V4HwQXcvzbyRg1xDU3CTgbPlqHHxnAdeXp6DuDEsTSkxZrC2
DlCPXm0+tgjWQN4q+MOpW57lCBKagn2rzD1voKw4a22w4XPi9KzEmb6YoRLTvcLR
icuq25hB2E9rG21HWL1/5uEJayRyFsmyHB+xXtQXb04XEolY0cvQjOvROaR5LeOL
hBxhS5zU04sPK4HX9Mb1
=HA0C
-----END PGP SIGNATURE-----

--K/NRh952CO+2tg14--
