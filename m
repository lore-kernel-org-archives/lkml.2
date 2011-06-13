Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab1FMJYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:24:48 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:41753 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab1FMJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:24:47 -0400
Date: Mon, 13 Jun 2011 12:24:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>,
        "open list:FREESCALE USB PER..." <linuxppc-dev@lists.ozlabs.org>,
        "open list:OMAP USB SUPPORT" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] usb:gadget: use min_t() macro instead of min()
Message-ID: <20110613092438.GK3633@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307877290-26672-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2feizKym29CxAecD"
Content-Disposition: inline
In-Reply-To: <1307877290-26672-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2feizKym29CxAecD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


On Sun, Jun 12, 2011 at 02:14:46PM +0300, Tatyana Brokhman wrote:
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

I need a sensible commit log for this. Why do we need to change all
min() to min_t() ?

--=20
balbi

--2feizKym29CxAecD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9ddWAAoJEAv8Txj19kN1oP4IAIpN/ZiTxdotBDFX1Q7Kx//H
q8ddGHEf9Gp4aYVY18OT25W1aRtQVVfMzbHxwssSN5ZRq7GRktnY/c3yV9ar1vB1
99Ao41XkWUCLhQKM0L+vQifG8Ufutom3VlYxl6GkmgNgj5cSsNzspNkQnGl5M6sO
hD7tNiwOznuwX4ygZ+vC4EhCq0vjnh5IY8PuJjmIr+t7V8qCJA/OOifit0/e6sdz
8VMiuNJQehqk8EYo2TcbVR9gnoID1mzbWeh5/LzlRz60uZSgDJdERidYcq/kcndO
K0jUCJvMKfySXoP9bhlPGxR8WUflFZqSjvIrB94VyWn5MWzXKOyVX5OciyQbLpA=
=awIV
-----END PGP SIGNATURE-----

--2feizKym29CxAecD--
