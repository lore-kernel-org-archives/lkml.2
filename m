Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab1BPA4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:56:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56588 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab1BPA4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:56:45 -0500
Date: Tue, 15 Feb 2011 19:56:40 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Trond.Myklebust@netapp.com
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: NFS Regression in commit 0b26a0bf6ff398
Message-ID: <20110216005640.GA2841@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

While testing some 2.6.38 work my rsync backup script started consuming
large amounts of memory (all available before dying with no more available
memory).  I have bisected the problem back to 0b26a0bf6ff398.  I am
unfamiliar with the NFS code so I don't know where to start looking for a
possible fix.  My backups files from my home directory to an NFS mounted
directory.  The NFS server is a Synology DS-411+ if it matters.  Let me know
if there is any other information I can provide.

Eric

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNWyDIAAoJEH65iIruGRnN8cIIAKzs8G4ZQKbje4FQCNSGVHiT
o7wxwngCKXkWUYQy8hBuWFwmzoWr2I3h5cbClFuG0bWB/lt5uJGhv+DtGNv8lOsO
dBJzctnGr64JRX0CnAtKQGliP0os3P9fJ75UF0PcJAOi9vgNkPfbW5UYfUf4wIQo
TAqEq030AZuetCiu2bEke8Dp/NvCvJKN0GiQwMkH/EW7WogYaq/RDUONe39n4qGW
f0p14ow9dflJVyjh0LcQ5aRyEKjOt9m+91GBQ43MJAhr1vyCqAvQG/Vf7ED53q+j
CkIsiE1qyNOiz8l54PJgmQJVfuqoG75Lel2Zp+m7ZZY+rYQFZ6OiIOMaBBbmwA0=
=cFJj
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
