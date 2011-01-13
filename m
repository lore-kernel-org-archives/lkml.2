Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab1AMPJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:09:40 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:53541 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab1AMPJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:09:37 -0500
Date: Thu, 13 Jan 2011 16:09:32 +0100
From: Nico Schottelius <nico-linux-2010122@schottelius.org>
To: Nico Schottelius <nico-linux-20101229@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37-rc7: screen black after several suspends
Message-ID: <20110113150932.GD15182@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-2010122@schottelius.org>,
	Nico Schottelius <nico-linux-20101229@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20110102101721.GA2277@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <20110102101721.GA2277@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.37-rc8-00033-gb518a64 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey devs,

Just for the record:

Some tens of SUCCESSFUL suspends & wakeups on 2.6.37-rc8-00033-gb518a64.

Xorg crashed once (black screen, not recoverable with tty switching),
restarted it, still works. Even with some lazy umounted nfs mounts,
even with LUKS devices / usb being used during suspend and removing
on wakeup.

This is probably the most stable kernel version I've seen in a long time!

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk0vFawACgkQ19zI5DGHffC0VACgvKAuyLUTquConh2SGa41gLtF
sUwAn3CHIlZ7JIPwUskqca4xoiAlBnuH
=nCe0
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
