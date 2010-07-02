Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0GBH1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:27:49 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:52120 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0GBH1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:27:48 -0400
Date: Fri, 2 Jul 2010 09:28:26 +0200
From: Nico Schottelius <nico-linux-20100702@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20100702@schottelius.org>
Subject: e1000e: receives no packets after resume
 (2.6.35-rc3-00262-g984bc96)
Message-ID: <20100702072826.GB16856@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100702@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-rc3-00262-g984bc96 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning hackers,

I've seen that in kernels before, but now suffering from it:
e1000e does not receive any packets after third resume:

---------------------------------------------------------------------------=
-----
[8:16] kr:clyde# dhcpcd eth0
dhcpcd[11589]: version 5.2.5 starting
dhcpcd[11589]: eth0: rebinding lease of 129.132.102.115
dhcpcd[11589]: eth0: broadcasting for a lease
^Cdhcpcd[11589]: received SIGINT, stopping
dhcpcd[11589]: eth0: removing interface
[8:16] kr:clyde# dhcpcd eth0
dhcpcd[11601]: version 5.2.5 starting
dhcpcd[11601]: eth0: rebinding lease of 129.132.102.115
dhcpcd[11601]: eth0: broadcasting for a lease
^Cdhcpcd[11601]: received SIGINT, stopping
dhcpcd[11601]: eth0: removing interface
[8:16] kr:clyde# dhcpcd eth0
dhcpcd[11784]: version 5.2.5 starting
dhcpcd[11784]: eth0: rebinding lease of 129.132.102.115
^Cdhcpcd[11784]: received SIGINT, stopping
dhcpcd[11784]: eth0: removing interface
[8:16] kr:clyde# dhcpcd eth0
dhcpcd[11830]: version 5.2.5 starting
dhcpcd[11830]: eth0: rebinding lease of 129.132.102.115
dhcpcd[11830]: eth0: broadcasting for a lease
dhcpcd[11830]: timed out
[8:17] kr:clyde# rmmod e1000e
[8:18] kr:clyde# modprobe e1000e
[8:18] kr:clyde# dhcpcd eth0   =20
dhcpcd[11855]: version 5.2.5 starting
dhcpcd[11855]: eth0: waiting for carrier
^Cdhcpcd[11855]: received SIGINT, stopping
dhcpcd[11855]: eth0: removing interface
[8:18] kr:clyde# dhcpcd eth0   =20
dhcpcd[11871]: version 5.2.5 starting
dhcpcd[11871]: eth0: rebinding lease of 129.132.102.115
dhcpcd[11871]: eth0: acknowledged 129.132.102.115 from 129.132.57.97
dhcpcd[11871]: eth0: checking for 129.132.102.115
dhcpcd[11871]: eth0: leased 129.132.102.115 for 86400 seconds
dhcpcd[11871]: forked to background, child pid 11892
[8:18] kr:clyde#=20
---------------------------------------------------------------------------=
-----

Are you aware of this issues?

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwtlRoACgkQ19zI5DGHffDhDwCgmT5BfNcSQUe9R5vd++RlZv7t
1acAn0ftexP0dkZT1PZmr/eiAV07CmQA
=pfc7
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
