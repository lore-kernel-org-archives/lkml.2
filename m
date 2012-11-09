Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2KISoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:44:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2KISok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:44:40 -0500
Date: Fri, 9 Nov 2012 19:44:36 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: harmony: Add ADT7641 temperature sensor
Message-ID: <20121109184436.GC7663@avionic-0098.mockup.avionic-design.de>
References: <1352465815-26984-1-git-send-email-thierry.reding@avionic-design.de>
 <20121109132257.GA29183@avionic-0098.mockup.avionic-design.de>
 <509D3F0D.5040204@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <509D3F0D.5040204@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:v6/V1YtX0qepPKf4lufkPplXHuMoA8Ngrv9NR8V3kaN
 lI5Tnovy0lBHoJXttwUlBodOSix0/xN73nEV0UfH2DIcabFFaQ
 EbRT+DtAZ9ZWVVaeC0Jw6pTvLblMM/7xM2Y4bSEyXiEHk3U7Qn
 zY/R8tJliOiKGd4+V7D7FfauBrc2jzx4zSWjVjg7Evuw77Jzyd
 igWYJHzA7fmkLBwCNSuEvgSG8L+xgoudFYTEdgjBfTrEFi9lGW
 P8P9VTPGetpDQ+ulx3ibWjvWTu/kvt/L7IbceginEUVknb+TVG
 mj0ziNlRgI7i/0a6T3sLL0nczb/QCnC6JJwOphVy4mNueqTmF2
 17/bKnzlFOKH04/utsxj6fWwzMUKvkoZ2mc1cCKP7TL/wsGTrS
 WSJYyx/Niypi3Kq/NniVE4Sbei+ywWkgPTF0KnoAYKoyMuRccI
 qG16Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 10:36:13AM -0700, Stephen Warren wrote:
> On 11/09/2012 06:22 AM, Thierry Reding wrote:
> > On Fri, Nov 09, 2012 at 01:56:55PM +0100, Thierry Reding wrote:
> >> The Harmony board has an Analog Devices ADT7461 temperature
> >> sensor connected to the DVC bus. It can be used to monitor the
> >> ambient (local) and on-die (remote) temperatures.
> >=20
> > Note that I haven't actually tested this, as I no longer have
> > access to Harmony hardware. Testing can easily be done either by
> > reading the files from sysfs directly or by running the sensors
> > utility from the lm-sensors package.
>=20
> OK, I can test this. The same comment about the DT node name that I
> made for the other patch applies here too.

Alright, I'll rename the node.

Thierry

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnU8UAAoJEN0jrNd/PrOhrooP/0ogmVmjGspVeerOHJZxaoIe
/MK8RmbB5Yw/K4fB+s5Pp8qV4zYIrUBn7iWu6Rq+jTU/aVTyD6C/VugBVWUcXeFs
n1byfG9EBwN6MTX368mXkEJaZGWLWlsL8lbP8ZjEgSi+So02CiW5SDjJX1eolRsI
e6EMUVWoe5m7am+h7xoTSnIZtwKRJwwGTj/PJk3WSoTn5vutsTjzacNF1skw85Or
qB4u7qH6p+cboRzOGz94qO8ao7GjwL26R4AyzzADJ/hP1LrOcNVWnG/FWBSCpLVO
KW65WfJZpHdDWLPj4oGUcfanUAM4xx6bqn1Yxceg3+K9T0dx0mqWo86AkiooRyLl
7pIwu3nEVVrNeTxxg35vLw7YtfgJm+Wdpab6ZlB6CvRzVdODrYw9FE8exHcBHPbk
NI8zIoTB2KOZrvM005WPd7DNMLWBg8k8IRy0YOp5yqw3rDS2X9/B/1PfNbR7pzmh
INZyAxNmPvcHfRLcc+g1DJ3t/cD12XgtrS2t7ZesNSzXYpCTEVWCBwhQf2/UN0VO
tBWmAZw4qPbFZW+E1KOn9sfVhj3e2+2M+/jE/LapoF9ZX7/TEcKAD8X0j1Zv6BDA
Rf2lJgwYSiOnpUpEQ8a7aOHHCZJ9apwBSi8ZJyqGs0I5+eBEB932VxGTt6qmP9vF
qYksBdOMgFE7tziipQ5U
=H/Eg
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
