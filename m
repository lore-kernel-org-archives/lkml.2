Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab1FIJpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:45:50 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:37694 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943Ab1FIJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:45:48 -0400
Date: Thu, 9 Jun 2011 12:45:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 7/10] usb:gadget: Add SuperSpeed support to
 the Gadget Framework
Message-ID: <20110609094539.GH13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <1307360469-29120-7-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zlo2GrDIozf6aQFY"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-7-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zlo2GrDIozf6aQFY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:51PM +0300, Tatyana Brokhman wrote:
> This patch adds the SuperSpeed functionality to the gadget framework.
> Support for new SuperSpeed BOS descriptor was added.
> Support for SET_FEATURE and GET_STATUS requests in SuperSpeed mode was
> added.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--Zlo2GrDIozf6aQFY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JZDAAoJEAv8Txj19kN1JVkH+wWpxMre2IuWx/+2qT6v5ilY
zhw2CEJsRm1gcNYXBEokxE2q7mV/pzC9U6z3iNtilsK65XGyRoFc3v6snDTS/WHE
oKgRO0/3iyKcc3iklGdhgl9TU1Qbt3DVPy5XDnXqljb6TTVHOICKo5/YlLOtXss5
1QytujnbWMJqVZxtbsr1guk9FWEEk3q5q32n5hwjpETOwPnqQU4GesghwVuLFnJo
4f3uBAHsbONHDe8nK0pq50JRfd9E7YYzUYbcQGM8Msa6bxozSbRDRFifTHgsPMfv
5EYydJXBZpdUmYWU1yHBMCEE5jVGfkvWHZXwPoo5BzFV+7rDOkLlJGV0rupB9ms=
=FlXT
-----END PGP SIGNATURE-----

--Zlo2GrDIozf6aQFY--
