Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1JJJDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:03:39 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:38647 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab1JJJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:03:37 -0400
Date: Mon, 10 Oct 2011 12:03:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111010090330.GE6685@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com>
 <CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com>
 <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
 <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com>
 <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 10, 2011 at 02:22:23PM +0530, Munegowda, Keshava wrote:
> Hi paul and Felipe
>=20
> Here is the highlights of the change in the design of  USB Host which
> we can do after kernel 3.2 release;
>=20
> 1. separate the TLL changes  from UHH
> 2. The TLL is be a new platform driver in ./drivers/mfd
> 3. the TLL platform driver will export apis  for enable/disable clocks
> and settings.

TLL should control its clocks through pm_runtime APIs like anything
else. If you really must export APIs to be used by UHH, you need to have
an API so that you can claim/release a TLL channel and get/put for
increasing/decreasing PM counters.

I still think though, you should try to avoid exporting OMAP-specific
APIs all over the place. Ideally, we would be able to have some way of
saying that UHH and TLL are closely related... something like having the
ability to say e.g. two devices are sibblings of each other, so that we
could ask for a sibbling to wakeup/sleep depending if we need it or not.

Dunno, maybe I'm drifting here, but I don't think exposing OMAP-specific
APIs is wise.

--=20
balbi

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOkrTiAAoJEIaOsuA1yqREuIoQALMJa0Zi4Bu1FHTY4gWKD00e
Ahsm3BFcAJiphQrTj22PKijUBYyj3NFzaYnvZ/BhKXk0HAIfk31XBSgtHVGV6EUs
DO+yxOqPUOk5AoA5Iznyyuk6Jbcr3ukHfXjfF6DqEYxIpiK6ugU6LaqJ4/7qNHlU
o0aZ1kAVQp7GDdeeS4gwhYapIqrbd2EwaXIvH0wr2Uv2smQsnwRQBZDRmtXsucVQ
EKBiJEH5pvxA+fJfQtfA6aJFgTgZff5icktErYiWTpyqf5jrg2oOBTvZe0xc/a4T
3gv6jYbe428Ry+q71Frmfizjd4iPnVnFiPwA2etpnHOcG8QmsBV7Zigh/Hk7OMOd
pOcpOhndhks+kjISr8afHs2DWRTcf0lLLpha/8fmskYS9U7CusnbnzLbnoJi3zGx
j2lkjfpVzV43KsXPCKsV/pvChhKupdtqSrRjNCETI9H/3B0vanrsMs1YkZmg1j4S
O9+8GpHmVxFjIiEVUua2L5hLct3rW6q5oJcIDP3xnbPvsW7/wRcdihrDZSd9fG8C
1eDuPdHYZjSzPFeTBaq5JC9SCVqb2aRYDZjHDadtjxaAEQB5RN1/djoNOj303Yew
qz6oI7oey7I4/aB+5ktYx80aT3oQ6OocQjIEI+32FByW8y71jQCPHX8I6It2ACL0
5GQ/eG9/R0mytDt9gukx
=8/Hr
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
