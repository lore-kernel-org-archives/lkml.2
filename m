Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab2EWKSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:18:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33387 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395Ab2EWKSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:18:37 -0400
Date: Wed, 23 May 2012 11:18:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jonghwa3.lee@samsung.com
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 2/2] regulator: Add support for MAX77686.
Message-ID: <20120523101834.GI4085@opensource.wolfsonmicro.com>
References: <y@samsung.com>
 <4fbb2ada.63de440a.589d.78e2@mx.google.com>
 <4FBC3FF0.5080408@samsung.com>
 <CAKew6eW2eGrBnzSGsr3N_dXSixXv-bkBo7xkbC-o9DNnwBhcuw@mail.gmail.com>
 <4FBC6A2D.6040408@samsung.com>
 <CAKew6eUew+=f-dGjJZD7Wy8Xt2f4smEhkYh=CUhx6Y_EMByFFw@mail.gmail.com>
 <4FBC76A8.2070004@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KrHCbChajFcK0yQE"
Content-Disposition: inline
In-Reply-To: <4FBC76A8.2070004@samsung.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KrHCbChajFcK0yQE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 02:33:28PM +0900, jonghwa3.lee@samsung.com wrote:

> I inform you my mfd driver has been confirmed by Samuel Oritz and there
> is no mfd private API. This situation looks unusual that we registers
> mfd driver and regulator driver separately. But how should we do? For
> corporation , i'm asking you to consider my suggestion.

Given all this discussion I'm going to ignore this patch for now and
wait for a repost after you've come to an agreement.

--KrHCbChajFcK0yQE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvLlyAAoJEBus8iNuMP3dHtkQAIdTQtJ6OnJo05vBU/rZMCcd
DmKlQof4lF3rcSN0K/w+ELwpEG3nM8etkxYNTlm/Yt9Vy1n9uTnMsLb+QvVEoAfX
DnjX7BwLuqBt+T1t89+P6OXLNPIFYiSw/54BWYr776G3OYWtrJVmnlpI5649vLYq
1HSFZ6FS3i51lbPwKI++6kknSPUvDEq9JpaP1f2P3uzSxAhEvwNXSpvT08kypZVA
tA42Gc9MZUbIK9yZ6AEbt7U8v2R7lb0J1UrTyfaiD86p5D2xmUomR+fqJ59auwPm
YfCdwNV7TSTEiNdxCHrFo2D5jqY2dufFKy8cWP4HXT5XHrL6P1vsH7nkXmAwdTUb
DK/QM5Gv+cBwsnszeAPWkUkw54b/XDWF9XwT7hUFipZpSsGy1fRZ+1oaIIzdEHfx
czAPQQNnvoe0MlGK8grxZi9gtjFO4ECONZu5ME89yrAyTHySnln11Tye6swia07Y
msgzIebW0CK/U0xflnFE/hdhcM4sBRkpCFrEAI4agvwDJPUatEJzIU7ydlSYdfE4
kWcYfYZRP/AyJVozMpTkBJ43Cj4Zc7xfvv2VzYPnIeHdt5Ym6qHPPC5UKPX+7rz8
1vgc0WuripkLtq1YW2gLfCOHh12QNUlLcHRrp3eNjZ5RDnzPt9Aa0sJpDIO0CZ+D
7bcDvP9m3xiC7h8Q7cxa
=eGON
-----END PGP SIGNATURE-----

--KrHCbChajFcK0yQE--
