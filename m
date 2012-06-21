Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2FUJOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:14:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44403 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769Ab2FUJOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:14:35 -0400
Date: Thu, 21 Jun 2012 10:14:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "Kim, Milo" <Milo.Kim@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, "Girdwood, Liam" <lrg@ti.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
Message-ID: <20120621091433.GH4037@opensource.wolfsonmicro.com>
References: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
 <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
 <CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRdC2OsRnuV8iIl8"
Content-Disposition: inline
In-Reply-To: <CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRdC2OsRnuV8iIl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 04:20:46PM +0800, Axel Lin wrote:

> I don't think this is the good way, other drivers may have this build problem.
> I think we can fix it by having the patch exporting
> devm_gpio_request_one upstrem ASAP.

This isn't any use until someone actually merges the patch which given
that it's for gpiolib could take a very long time.

--jRdC2OsRnuV8iIl8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4uXxAAoJEBus8iNuMP3dh/IQAI04nXbUpsvz7eeN2ysqtFjl
YnAGayfLcUOuKlwvrB1izwfN6i97Am8makdOQIujbpqSnA5AdCXZJooPXFUdJac0
RWx1+ciA4Mk8WGrssO++QARXRuFceq9+TcNgLAc7qaVb1Lb+Zys6GKKRBMw3nb3D
7kPZXlXW0bZ51RJaveZb1WppQIPF+y5n9d8cwGiOkEJ5vmhNh0d4ONu6dIp8C2BL
jpT+o5zniOSO3J3OXriJ77tUcmdV4M0L0vukqMQTnMN676InqKoAx1bSeb3cpYR0
WtVHK8rSWIgZzBnuvZa0hnFLwB6wA9x++i9zS1VGfdJ52q16qtKNRNqkikPkvwo6
VkJPjgGBGi1hbr412TrErB5Kn/2iNFFjoPJP2kOeILjCOFWjFvhmp4T5hUNnv125
7AdeS/QP3LxzFTMpzTgowXXXKbu3VbtfertfR+uwmbzE9Td3J70jIwe83UjVfra4
0ZeMZaIYLyQSXpYaPlCZ8sUs+e0peEm3qZqxhkJW6uENxTz/OTcy3y9VMlw9s4Dh
X7ocI6wKJzS8oZ62RgYv5XHSHUfsQ42UqA9duDOwc6k83map+zLh8qw6Nus9L3sn
2VSiSTnuEmYmo0GvslSuDkA+0Po3cylj4sSxcwJHCqYoWONXZPiyicSCJwhJw+5h
TMy8J8Z8SRA4EeUL1l/l
=Noc5
-----END PGP SIGNATURE-----

--jRdC2OsRnuV8iIl8--
