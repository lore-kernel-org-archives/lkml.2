Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2EGOvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:51:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38304 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab2EGOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:51:30 -0400
Date: Mon, 7 May 2012 15:51:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 4/4] regulator: tps62360: Provide settling time for
 voltage change
Message-ID: <20120507145126.GH17002@opensource.wolfsonmicro.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
 <1336376139-1048-5-git-send-email-ldewangan@nvidia.com>
 <20120507112321.GI4415@opensource.wolfsonmicro.com>
 <4FA7C31C.7000309@nvidia.com>
 <20120507142245.GF17002@opensource.wolfsonmicro.com>
 <4FA7DFF9.5010606@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Content-Disposition: inline
In-Reply-To: <4FA7DFF9.5010606@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 08:15:13PM +0530, Laxman Dewangan wrote:

> Actually I saw the multiple driver which uses
> set_bits()/clear_bits() and thought that this is good way of writing
> clean code and so developed multiple driver surrounding these apis.
> Now seems it is easy for me to use these apis. May be it is my
> personal taste.

It's a taste thing, a lot of those drivers are doing this because they
cloned the wm8350 driver (or something else which was based off the
wm8350 driver - it was the first of these).

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp+FcAAoJEBus8iNuMP3dMrsP/0ChF5XoMqf+Dp5dK6V4xp0s
u2/4KkG93zNLBDioop6Bl0l6uqmVKo00NXr6NqTmhNl91tQCYOx3oTM2aSsBUX4y
dWnC6UPr++aad5Y0bJFD3qQTNx3Ly75Ins3z3chI1Ad4OkBHRKZxLQiQi7eJ1GqT
Hv2xXAbWEh6O8/4l+lKsNJM6WHpi3lfJlO4lEPPxPBstCoUpYmhkUijVxe15rBId
2+VB+geTXZrEKbbfTwBPphePD29AaXovhs8asZY2LF/4FAldpf7N0pVwKEh8bG3B
yYZHs7edkiihLimOUxs5UIQNTEAk+gveVZdXGeg+GHVL1LpVfl0LlCIk5mxm8yNa
LtRv685x9RlXP2IqrjRvkK+DTkuI3yGV0GQ9/nRpRLaBfUebZd1F4SrImbdmdIt4
3RwDSyMo8qJlUL1s8KkJlqZLu1m//PRSr+2j0H8GqQf61vh5CqlS4419ecrD5Nu8
1Hn0dbOG6C071tSgopsz0v13vWS89/F5L8+hwfisF/+mtBh4Xb29V6BRRlZFYrT5
8hLGUOBELgKP73sgDE/ukL3Fdu9jxM1/ZaJ7P1iJbPSPFU/8gdQun/6jRH6x3Ok8
/+RnmzQ73ngnNyy44lq233sErLNxmEqgwLLcXfqYbCsL8/1sCUeyDTchcFoGn7Re
YequPm/vN0sMvVPYN3Au
=xlyL
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
