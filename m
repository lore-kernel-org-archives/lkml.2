Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab1DFSr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:47:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42857 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab1DFSr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:47:56 -0400
Date: Wed, 6 Apr 2011 14:47:53 -0400
From: Eric B Munson <emunson@mgebm.net>
To: linux-kernel@vger.kernel.org
Cc: dave@linux.vnet.ibm.com
Subject: 2.6.39-rc2 boot crash
Message-ID: <20110406184753.GA7691@mgebm.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am seeing a boot crash on my machine with 2.6.39-rc2.  I don't yet have
netconsole setup and I don't have serial so the best I can do at the moment
is a couple of pictures of the stack trace.

http://tinypic.com/r/2zsr19i/7

And=20

http://tinypic.com/r/2iw22dj/7

I will try and get a net console working for better output, is there
anything else that would help?

Thanks,
Eric

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNnLVZAAoJEH65iIruGRnNbw8H/2mghRRQ/E1NuqAqw3+Z3X+X
rEAmyoL+3ldIByZHpysuR7xNnkgyjSmPLaO+PS8rq27QjQMhG/lev6PG+d9Jv5cG
LnZ7AT5hnBVov0YEyxQnklNimJRuSl8XwwvcSba9SDoO3MLY+HXjX3OAaZx7O9Pv
n1mWS5gLyGoJZm0vLXXhHpm6HK/r+5IzxHHrMkA4mG1+VDYbBOZJSVAih0yyGsWj
NC4NrentR7RolXvg7tNWt6UUn6A83ucCshBpz33dOVk250XaFHsujhfXOuRGijOE
PHtcC5WTr+sBe0nqDvi4C/o1hOcpMmn/Y51etPnZ8eWs+s5P3UnT001IB+50fjE=
=IJrY
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
