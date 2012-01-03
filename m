Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2ACTcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:32:05 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35417 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800Ab2ACTb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:31:58 -0500
X-Sasl-enc: AQ7oVeYOZOp2RLtAv4bIk+JHVBApoBHmpwStIOQXjenq 1325619117
Date: Tue, 3 Jan 2012 11:31:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.1.7
Message-ID: <20120103193115.GA1787@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.1.7 kernel.

It contains a single bugfix for resume issues that were reported by a
lot of people.  If you didn't have this problem, no need to upgrade.

The updated 3.1.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.1.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                  |    2 +-
 kernel/time/clockevents.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Greg Kroah-Hartman (1):
      Linux 3.1.7

Linus Torvalds (1):
      Revert "clockevents: Set noop handler in clockevents_exchange_device()"


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPA1eDAAoJEDjbvchgkmk+7ssP/14y/Z5UFDTADdovgwpfd0QH
GzqMs6O57kl49Z46rbbE4jvVTjSNH2DZBQ2LAlH057+l0QJSdXmFGzju+po5BMVX
l1ylA+QNFqZgonkSxs2ZAMDkc753yfasUXj8uF2OtuyYG4L986bZ5BGJpqZOxXGQ
KnovVlgMa6i03wF0lNtvi+++pZiGxW9Dsku+ougv8i0lE+1gOayXQaw/z9/tciTe
uJDezSoD2Ny3HQNXllX9BG6G/71VjRsIVc9ZZrgQkpKJU4hJWMS6qscOtvQvRFu/
JSW1bR9SHQflEsWBwR8o2x1tZbblAUf5wMHgVuT6DQu8nJAwOjXmdT47V25UyCk+
2hPpON02Pfgy+lJczC+9r8reF+pvWKkfRlqpygcCHXYKCjid0RDPm4bfFHn09V/+
LlSXRMuSQK/rl+mDUtur9kyh4eXkIoJwGzQVi87H2rW8Q1f/n4b878KChsX4ljSs
C2oWLLP1361Vx/5M3SofciUAm7rLN/GZmxJ5pRHr6BGwY2Grll8LyFCrUie/NUyn
AtEG+Dj452yqdLLa0WD5LsIJWPL6P+knXidB/Ra9/1QU4hjrtZvVOYVzYWb0Rsm2
uEylzlhskQwToKP8yGCL2NzG/3sys3uDYDPsbpy/yQmg6U2iZUjzp2Naiqf/loHE
iW0ABtcddtM05ZNH1I7v
=Ylhz
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
