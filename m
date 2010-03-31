Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0CaDGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:06:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39016 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0CaDGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:06:06 -0400
Date: Wed, 31 Mar 2010 05:06:02 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: amit.kucheria@canonical.com, netdev@vger.kernel.org,
       s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
       kernel-team@lists.ubuntu.com, gerg@uclinux.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
	detection
Message-ID: <20100331030602.GD3520@pengutronix.de>
References: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com> <20100327125703.GB5880@pengutronix.de> <4BB06769.7040708@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <4BB06769.7040708@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2010 at 04:40:09PM +0800, Bryan Wu wrote:
> On 03/27/2010 08:57 PM, Wolfram Sang wrote:
>> On Fri, Mar 26, 2010 at 05:50:52PM +0800, Bryan Wu wrote:
>>> BugLink: http://bugs.launchpad.net/bugs/457878
>>>
>>>   - removed old MII phy control code
>>>   - add phylib supporting
>>>   - add ethtool interface to make user space NetworkManager works
>>>
>>> Tested on Freescale i.MX51 Babbage board.
>>
>> Sadly, I have problems here booting a custom board:
>>
>
> Firstly, I working on our Ubuntu Lucid 2.6.31 based kernel. This patch wo=
rks
> fine on our system. Then I forward port it to 2.6.34-rc2 Linus mainline k=
ernel.
> It also works fine on my hardware.

Hmm, can I provide some more information to get an idea what is happening h=
ere?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuyvBoACgkQD27XaX1/VRsmMwCeKfQmn0y9V/UZzx5oy5+LV7GA
slUAnjLhCMms5PSTJWw/U+m4nR/M4Us4
=EygU
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
