Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab2BXKFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:05:20 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54305 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756683Ab2BXKFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:05:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.152.147.1 as permitted sender) smtp.mail=balbi@ti.com
Date: Fri, 24 Feb 2012 12:05:14 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Eibach, Dirk" <Eibach@gdsys.de>
Cc: Shengzhou.Liu@freescale.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stern@rowland.harvard.edu
Subject: Re: Commit 529febe breaks usb on Freescale P1022
Message-ID: <20120224100513.GH17178@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4vpci17Ql0Nrbul2"
Content-Disposition: inline
In-Reply-To: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4vpci17Ql0Nrbul2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2012 at 09:31:49AM +0100, Eibach, Dirk wrote:
> This commit introduces a check for the USB PHY clock.
> Problem is that CTRL_PHY_CLK_VALID bit seems not to be present on all
> Freescale ehci implementations, at least P1022 does not have it. So this
> check always fails and the driver never gets loaded.=20

hmm, you would need a revision check on that function then.

--=20
balbi

--4vpci17Ql0Nrbul2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR2DZAAoJEIaOsuA1yqREtFkP/1MiVOd2xGlXoncqjHYkVpzK
CpED4cTw2xkNhUgegL5ec9+L6J+89oa9ctNG8+TVKQysqy1oZQ1WwPzboCm4gJrp
yk9IEjaBdKBi8IYgUy7xVycVIPHqedJgByhc/Ma2c1l2hn7S0zP2NZZrklFj+QRM
loLX46WIhjSunuURZ16qVHXfWMyUeJJDRa2fRtaVhCPVbD0qWOpEIX993/kRgvCh
1zUePI8BPoUsjvvYsuFcAdh1c+uIdoNoMsCnImZw4VxgDLLYh/ZnlJrce1KmWpCj
CcJuB0LNxqUaL3ego10Rx81CESHu5BczjWcjhTYuNoyZJ7TYo5VwDnSglpKWfgVd
/Law6CPDeftmjdKUG/MHyQEvn/WaKccdZavlCEmm/cfIxBjzhS2xYWgLL+8v7F54
4wHz2vLMhwjNzU83igoEDGUmKd9YdCtYxVrTovM+gacA+4c88aou+7AXeUrZ75DA
GgIr0jX5zZ05e91usKvFnhWCp2bD0lPiJ69vKSzVwjYQe85ydB4YblsucOLxketm
t4Nzp3qC2KiQSMNCYkF5oMsNAwQpLyLB3NyskTtb8+ofo+WXPxzVGKPEe3D3yiR4
0HqC+8Ig/YQr+/Z8AOeBJK5ILIYUMOXUVQG8HmfwM3ebnkpsBek05BnU6rp/6og3
H/2Ce8JTX5MXniS8rmcH
=gIZX
-----END PGP SIGNATURE-----

--4vpci17Ql0Nrbul2--
