Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1LQXrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 18:47:05 -0500
Received: from home.keithp.com ([63.227.221.253]:34139 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab1LQXrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 18:47:04 -0500
From: Keith Packard <keithp@keithp.com>
To: Patrik Kullman <patrik.kullman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915: 3.2 rc1/2 KMS regression
In-Reply-To: <CAGPN=9Sesv8GMgj1rbvqDsns6=O-Nao4=mZ72QYu+4-SiY9OmA@mail.gmail.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com> <861usye0og.fsf@sumi.keithp.com> <CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com> <86sjlccchg.fsf@sumi.keithp.com> <CAGPN=9SLsESVPdwhBwJN9G+nkENcFDqhrcva8GC-VTnx_E=apg@mail.gmail.com> <86pqge96z1.fsf@sumi.keithp.com> <CAGPN=9RZgCJy9hF4RqY1BLmC7cA7QWavWfRM26U3czWZ6RBNMQ@mail.gmail.com> <CAGPN=9Tk69_-oNZpabY+9pWnjdLR=AdMY1N7s9iCkRsonCsotQ@mail.gmail.com> <86d3cc5f1d.fsf@sumi.keithp.com> <CAGPN=9Sesv8GMgj1rbvqDsns6=O-Nao4=mZ72QYu+4-SiY9OmA@mail.gmail.com>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 17 Dec 2011 15:47:58 -0800
Message-ID: <868vma3glt.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Dec 2011 12:10:45 +0100, Patrik Kullman <patrik.kullman@gmail.co=
m> wrote:
> This has been solved with commit
> ed4a51842a9d9e618d4f4c31349b15b974dba5df in 3.2-rc6.

Thanks for your help in resolving this regression.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTu0qLjYtFsjWk68qAQg/WBAAgubzOSkNvYtKULzhgaYp1Ytey9R9YFfK
uLNHteubXhK6xgybDHAeF6fouyXIPCEi6qCBO/z0SF1C8n0fPt3VksJUBFky33Io
90UYsAvvvlyYAZrrQcDqNKXh3roSrMN7aHkjjAoyM0w3POJsxUs6gqH2z3+ZUKZs
VQwmzSgL3hyNJcZkS5ApdOWSpRb7txTpqoeOL7CkM4nvMwZ0dt4fod4bcFY+fy3o
6XF9ZLsPzTzbA69DACNVxEH6xivmJynJ/lWl+FrabcAXYV2cwMePYPPRH9lUXWM4
CEaU9wA8k+/dHq449Jc+j2m9IJhLDzuYDjWDMb20Yz0+PpGODhBPHm0ZfEQDBnff
t7+mHer0ZfTG2wWJDHlAyNLW+cMIBVZQ105FHXY/6fFpW5V+yWksfiz8qjSq+m2j
KkRVZwSTw9/fzHVXHjSNAYn8or2TCx6i1IfHYta0Tl6N8axtCLuTYIeHEyVup1Hz
thZBl3mH8T5XRmlWolELxGXGB9ZAMOf+cdkzKg8G/4mZjXWGsfDYwwtF9iPICgi4
eBnM7BVu/5DTM9MB8HEfqbId/mR/uvgZjoG1cKlgLmdrsKelKbmIicaxyd7PXeoE
2QGwigQv+qb8R5aXiU4HHP5R5hnYZoTKljG2gwtk06c+Kuxr1chbELb3U/fAMnpC
JU5g2Ht/AdY=
=aR94
-----END PGP SIGNATURE-----
--=-=-=--
