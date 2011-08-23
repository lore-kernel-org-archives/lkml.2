Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab1HWRVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:21:33 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:37586 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab1HWRVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:21:16 -0400
Date: Tue, 23 Aug 2011 20:21:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Michal Nazarewicz <mnazarewicz@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110823172111.GD10996@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1108231141400.2069-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108231141400.2069-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 11:43:44AM -0400, Alan Stern wrote:
> > if they are both part of the of the same configuration, full speed.
> > Otherwise Audio won't work. If they are part of different
> > configurations, then maximum_speed will be defined by the chosen config,
> > no ?
>=20
> No.  The speed has to be chosen first, when the gadget connects to the=20
> host.  The config isn't chosen until later, after the host retrieves=20
> the various descriptors and decides among them.

true

> > I stand with the fact that if they are part of the same configuration,
> > there's no way around it, storage will have to come down to full speed.
> > Unless I'm missing something.
>=20
> What if they are in different configurations?

then you use the fastest speed between both configurations?

--=20
balbi

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU+GHAAoJEAv8Txj19kN1F74H/A64XQeHnk+rkVTr5o1tiMfB
0El68iegkgFda1NGQMsiNgSjU6Jcl9JmqFHJevGt0EMItBetHN38Fh0yF59WZ0rT
buouxglYU83Jr+w1hVkX/wZbXTHlhpe1D3PzE3T4etHAUdgHhIde0YWT8YSTInul
UM/7l6EnLRRi1Osw/uzp1ytJv2imFKyUEadtFLiC5AYgoCK3ygv9aX/a0mbCYE71
EhKUH6A/BKJGMmlMT1qhK5GezbsDgjSUZmqrnfknLlb3NPUvfNmofI60vaoWljBr
Z5pNDY4uP7cR5puHgWoqNv8h6fgQ2QdaUnHaQ77TsIw2FybRJWR7ZQ2BN3LFuVI=
=wd5d
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
