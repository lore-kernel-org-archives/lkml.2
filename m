Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0KKStv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:49:51 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:49465
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230Ab0KKStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:49:49 -0500
Date: Thu, 11 Nov 2010 10:49:46 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Message-ID: <20101111184946.GC20296@one-eyed-alien.net>
Mail-Followup-To: Luben Tuikov <ltuikov@yahoo.com>,
	Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20101111174322.GB20296@one-eyed-alien.net> <673670.8195.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
In-Reply-To: <673670.8195.qm@web31801.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 11 Nov 2010 10:49:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 11, 2010 at 10:27:11AM -0800, Luben Tuikov wrote:
> The patch uses SCSI functions to abstract the sense information irrespect=
ive of the type of format of sense data.

Looks reasonable.  The underlying SCSI functions seem to all have the tests
to distinguish between sense format types.  Let's just hope there are no
devices out there which can confuse those tests, or we'll be buried in
regressions.

ACKed-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

My mother not mind to die for stoppink Windows NT!  She is rememberink=20
Stalin!
					-- Pitr
User Friendly, 9/6/1998

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFM3DrK3gL8qCooyc4RAky0AJ9lH9VGKO2/jkDqQKrcloV5a4TJWgCeILba
VjOrIrVK99RYWvEj1e5qzhY=
=PSWE
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
