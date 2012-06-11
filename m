Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2FKO2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:28:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48511 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2FKO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:28:21 -0400
Date: Mon, 11 Jun 2012 22:27:53 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Message-ID: <20120611142752.GS11439@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-10-git-send-email-lee.jones@linaro.org>
 <4FCDDE58.5010501@linaro.org>
 <20120605102900.GP23408@opensource.wolfsonmicro.com>
 <4FCDE0A4.8070107@linaro.org>
 <20120605104201.GR23408@opensource.wolfsonmicro.com>
 <4FD5D49C.6070106@linaro.org>
 <20120611120820.GN11439@opensource.wolfsonmicro.com>
 <4FD5F3D2.2050500@linaro.org>
 <4FD5FBAF.1060002@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jesV4P1FjH8FXPjZ"
Content-Disposition: inline
In-Reply-To: <4FD5FBAF.1060002@linaro.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 09/22] regulator: Change db8500-prcmu match names to
 reflect Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jesV4P1FjH8FXPjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 03:07:43PM +0100, Lee Jones wrote:
> >>Well, I guess I'll end up dulplicating the commits :/

> >Duplicating them?

> Ah, you mean that you've already sent them to -next?

Yeah, I've already got them on a branch I don't really want to rebase.

> That's no problem though. Won't Git just sling them out at pull-time?

It'll merge out fine, it's just icky having the same thing appear twice
in history.  Not the end of the world.

--jesV4P1FjH8FXPjZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1gBUAAoJEBus8iNuMP3dwbkP/0rk2tV9JAVznRzEpS2fmBKb
vsbijoZg25VCSMkbyx9uBVZhfr+xDfs5mz6b4oMyTlGE1FUuPMiAUjRJgPVv4CU/
JYOdhz1cu91oLjzSgnfyjPhS6ESOVsnKD07l7by6dSuuNe+Hkx7jbGCl0FeI5pLL
VZ3XPIPpZVFFkB8XAqeIk0QmrXlUrr3XHCpP3ss2cETh15rOIUb/u6lVXDtjzmAX
yuWgdl2N2YrW2FxoSyZixTSFmyrXCE4NJE72+q9GG6I9ZUlGuPSAxNOWJpy6MXgB
QwylyP8xu4Ve+xrzTOALIRCCxoWDBNxdkcKbFymE+XxuEzGpPsEEUuS/HaLThKpR
ag+6hiw44102v7N6Adrfu+g86YzeCgSDk5YrKua4Vv3UubLRY1PXOY218qPWNYzX
4vQVCkM78Yf1uJJ9iVat4UNPycuwaBEMrl94H64bE7yfRy0K3og2duSkgNokVMV+
/XyOi7Bw2iq5w4nD+qqSg/1idddovifdIR4ztYp9eG/qDhCgtf2HtusBoUQeUn7L
yYTqBqYnahJqnAzwySHhsg7GoD1EFbf5Obq85R+1BCGeX5ACMVvINqKt8pYjx7Px
k7i4LBSLY2a+nCt5Y2TXCwcj6sjdHSCdUeGg3hNBbyT+/hFkBt7mxSYzd2xaNGqG
JECb/9wCueiKynLAiaDJ
=zVi8
-----END PGP SIGNATURE-----

--jesV4P1FjH8FXPjZ--
