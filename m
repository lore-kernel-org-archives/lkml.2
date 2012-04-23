Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2DWLFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:05:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42436 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab2DWLF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:05:26 -0400
Date: Mon, 23 Apr 2012 12:05:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
Message-ID: <20120423110522.GB8318@opensource.wolfsonmicro.com>
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com>
 <20120423101804.GA8318@opensource.wolfsonmicro.com>
 <4F953455.3080002@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <4F953455.3080002@stericsson.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 23, 2012 at 12:52:05PM +0200, Ulf Hansson wrote:

> I realize that using boot_on, which has been around for quite some
> time could have problems.  If not using the existing boot_on
> constraint, do you have an idea of how to accomplish what I want?
> Should I invent a new constraint option to be used in
> regulator_init_complete!?

To be honest I don't entirely understand what your goal is at the system
level - the current idea is that either the regulator will be marked as
always_on or it should be enabled by a consumer.  What is the scenario
in which neither of these is sufficient?

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlTdqAAoJEBus8iNuMP3dYIIP+gOXto44LAldQ69DZrFd56li
Uv1EwC/3jl8m7At8CWnTiYQQgS/Oy4OKXFYXj5nLjRmv8G+I0AdCDK8KbAyDQH0H
/kHKsXoYfMgvtwaNMiiUsvAW0mCQOHopy7EK29zjTXXmD32ptUhPhOFWCBaNCGie
8+QaWeX2AjKtgQjgRskD/uW7xACDN4iEMrevvsZnXtyZMcn0ApTtHTQTrt0yMVLR
YXC9emIKTZX+UJUev62zqloaUWxjf1Nc7ia5tH4mWR7GttZqqEfy2XivDO7i38fG
UrxrFpd0TcfRtr/MEvQNSVpKXFt/SGYn6RhtXKY9tPbdWXY+I4kpFm06t/BDdEjt
chxb5yvnBhYlr+LYOegL5l+OoPqWKRDj4IFB/ydFZJdJzP/H18gDeYSlZbMbhaqQ
aG57h/5K3xnS4QTjPGpQk5QOmVTQLqU4RYBMbMHMuMaSmoMnC0CuUEIZ0O11RSI0
V7YtOwn5Kz2PtKnQ3Yg5GxEG6KPolM8Gk+9xW0al9Orir1CDIdo0VH3nhQaS/mw5
ycMbBLABqgb+gVUmd/OCu772qFYAHBZdaftYIQpXrZaMZn0J9+Wh1QikxPCnoFOf
OJt/IrLstto107COTpaHrArfkN/C5+AxjlPOPkvG+ZXzhBs9iRxVILyghJzvx4Mg
PGrfOIzPNL8wAB3tYbDN
=tHsT
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
