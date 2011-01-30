Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1A3KkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 05:40:06 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:43329 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1A3KkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 05:40:05 -0500
Date: Sun, 30 Jan 2011 11:32:41 +0100
From: Nico Schottelius <nico-kernel-20110117@schottelius.org>
To: Nico Schottelius <nico-kernel-20110117@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: More display errors in 2.6.38-rc2-00175-g6fb1b30 (was
 2.6.38-rc2-00175-g6fb1b30)
Message-ID: <20110130103241.GA26556@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-20110117@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20110128202905.GB3395@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20110128202905.GB3395@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.38-rc2-00274-g1f0324c x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Fri, Jan 28, 2011 at 09:29:05PM +0100]:
> With 2.6.38-rc2-00175-g6fb1b30 I get a new version of broken
> display I've never seen before: The display looks like a misconfigured
> tv after 2-3 suspends. Switching to a different tty was possible (though
> still same broken display, but allowed a reboot) one time, the other time=
=20
> the system completly froze.


This time I can produce some logs, as only my primary notebook display
is completly broken, the external monitor is working fine.

Attached are xorg, dmesg + kernel config.

I've to emphasize that this used to work better in 2.6.37.

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk1FPkkACgkQ19zI5DGHffDRRwCeJqQMZBJeAGpNTurF8oBzLetU
04cAoISKS0caQJnnGFEpJF/8NVaUp2aK
=rDuT
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
