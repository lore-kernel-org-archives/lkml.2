Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0D0Ihi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:37:38 -0400
Received: from sgn-x201-01.ethz.ch ([129.132.102.115]:58335 "EHLO
	kr.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306Ab0D0Ihh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:37:37 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 04:37:36 EDT
Date: Tue, 27 Apr 2010 10:32:02 +0200
From: Nico Schottelius <nico-linux-20100427@schottelius.org>
To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-2.6.34-rc5 suspend issues
Message-ID: <20100427083202.GA3143@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100427074609.GA3261@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20100427074609.GA3261@ikn.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34-rc5-NS-00211-gb91ce4d x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Nico Schottelius [Tue, Apr 27, 2010 at 09:46:09AM +0200]:
> [..]=20
> - suspend & resume works once
> - second time system
>   b) suspends, but comes up with the bios screen after resume
>      and hangs there forever (2.6.34-*)

Just tested on latest linux-2.6, the
same happens on 2.6.34-rc5-00211-gb91ce4d.

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWoQIACgkQ19zI5DGHffDH9ACdG9Zvp9ZITlnwpMPArusaUIzt
P7kAnRV3bSWIRXj7iwkJytYiFihi+5eu
=9AZ4
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
