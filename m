Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1KRT2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:28:19 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56099 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab1KRT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:28:16 -0500
Date: Fri, 18 Nov 2011 21:28:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, Felipe Balbi <balbi@ti.com>,
        Tejun Heo <tj@kernel.org>, Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH v2] ahci: platform support for suspend/resume
Message-ID: <20111118192809.GF11736@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1321643410-16102-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mjqg7Yu+0hL22rav"
Content-Disposition: inline
In-Reply-To: <1321643410-16102-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mjqg7Yu+0hL22rav
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 18, 2011 at 11:10:10AM -0800, Brian Norris wrote:
> Add platform hooks for custom suspend() and resume() functions. The
> generic suspend/resume code in drivers/ata/ahci_platform.c is adapted
> from the PCI version in drivers/ata/ahci.c.
>=20
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Mjqg7Yu+0hL22rav
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxrHJAAoJEIaOsuA1yqREKUEQAJflTGb45/bw3wHj62vGuIrl
469kpAsIbhwGeAbkdLYNUMwbuMj7EsDHMdTfp7BqIKUg63PpTfcFM6Zmo5nNHSju
S3rjD0U48Rfv/Q4xEtSuHaWmXHmbmz7PV6OYPLl+5++1cUAWhzLpFf5fSiXyHwEI
5GVzwyx9yWkSrJtPXIlz4wYTk/ixA+XKtD2RY69TWttRf0AhBApvaMmfAwzCMc9j
mQhUibVb3/NacV+W2hnaAn4yQVzxwVQQvevnVhkEuOr/upL/aO1vZP1hmxkG0ApH
PMa6VzV2FQpQ42MHOOt3yUu1cQCHt4hqURbgE2HL6HLm0b+oLUeAPqOWV5Tm5ZpE
jilCDIbcS0WiviSXqX1EmqWToiwlB834UkACAlp+Ha4tHXoFZWx40RPk5RMlGt5C
DUq30EQQXCMY/HLKHQraRaUI2q6Q1MIs01qRU04six5m5VodUk5DkJ38wkKr0QFV
MksE2GHaJdi4/rcvz+yqwnsxAv+VGu+m61MaqtFCV+qZgGSEsS+MaHpL+7fPbfFF
lybg1WjaPZXC3XAF55MWUr2vBFCn8OLQOCfsulZ0BapjsIxmwkPO0HDK81hPC/cC
MIdbj95uuPc9CcNrwYNxOrSBqTh9o4emSocqbtl16wjJ44e8J6SkR6dTbUYwkJXU
DgPbEFoi5ZJNeiqb+PHB
=NZuK
-----END PGP SIGNATURE-----

--Mjqg7Yu+0hL22rav--
