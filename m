Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1DESIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:08:05 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:33540
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546Ab1DESID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:08:03 -0400
X-Greylist: delayed 1061 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 14:08:02 EDT
Date: Tue, 5 Apr 2011 10:50:10 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Olech <tony.olech@elandigitalsystems.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 25/34] usb/ftdi-elan: Drop __TIME__ usage
Message-ID: <20110405175010.GB22862@one-eyed-alien.net>
Mail-Followup-To: Michal Marek <mmarek@suse.cz>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tony Olech <tony.olech@elandigitalsystems.com>,
	linux-usb@vger.kernel.org
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-26-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <1302015561-21047-26-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2011 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 05 Apr 2011 10:50:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 05, 2011 at 04:59:12PM +0200, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.

What about drivers built as modules, which may be compiled at a different
time than the rest of the kernel?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Why am I talking to a toilet brush?
					-- CEO
User Friendly, 4/30/1998

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFNm1ZS3gL8qCooyc4RAnqaAJ0fjD3MHj2nnJrU/1GyWZ/uT4+llQCfdwVJ
1b5NneGgtex0pZVmMXIfdsY=
=xC/n
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
