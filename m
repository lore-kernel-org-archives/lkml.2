Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab0DVUVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:21:55 -0400
Received: from deliverator10.gatech.edu ([130.207.160.100]:53774 "EHLO
	deliverator10.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab0DVUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:21:30 -0400
X-Greylist: delayed 1558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 16:21:30 EDT
Date: Thu, 22 Apr 2010 15:54:13 -0400
From: Evan McClain <evan.mcclain@gatech.edu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [051/197] backlight: mbp_nvidia_bl - add five more MacBook
 variants
Message-ID: <20100422195413.GA10849@macbook.site>
References: <20100422191857.GA13268@kroah.com>
 <20100422190911.935042749@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20100422190911.935042749@kvm.kroah.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 22, 2010 at 12:08:22PM -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.

Apparently the MacBook1,1 reports the manufacturer as Apple Computer, Inc.

A patch was submitted here: http://lkml.org/lkml/2010/3/23/412

Steffen R=F6cker wasn't sure about the MacBook2,1 but according to sample
dmidecode outputs:
http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg07914.html
and
http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg09304.html
for MacBook1,1 and MacBook2,1 systems respectively, MacBook2,1 reports
as Apple Inc. as in my original patch.

Sorry for not catching this earlier.
--=20
Evan McClain
Aerospace Engineering
Graduate Student Senator  .
evan.mcclain@gatech.edu  ..:

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iHwEABECADwFAkvQqWU1FIAAAAAAFQAXcGthLWFkZHJlc3NAZ251cGcub3JnZXZh
bi5tY2NsYWluQGdhdGVjaC5lZHUACgkQvbxY5xzjycC1BQCfTgryXtajLWYjmmTK
pYTZ97+hWHkAniKWBT1z1ZtrRj35peoJhogFo7+Y
=Pxyl
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
