Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2DWXLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:11:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:57538 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab2DWXLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:11:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="134409892"
Date: Mon, 23 Apr 2012 16:11:19 -0700
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
To: Chris Boot <bootc@bootc.net>
Cc: <e1000-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nix@esperi.org.uk>,
        <carolyn.wyborny@intel.com>
Subject: Re: [PATCH RFC 0/2] e1000e: 82574 also needs ASPM L1 completely
 disabled
Message-ID: <20120423161119.0000022f@unknown>
In-Reply-To: <1335216578-21542-1-git-send-email-bootc@bootc.net>
References: <9BBC4E0CF881AA4299206E2E1412B6260E512E0C@ORSMSX102.amr.corp.intel.com>
	<1335216578-21542-1-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10cvs7 (GTK+ 2.16.6; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/_GqVr+9M/caExEfma/f495s"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_GqVr+9M/caExEfma/f495s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Apr 2012 22:29:36 +0100
Chris Boot <bootc@bootc.net> wrote:
> Please note I haven't as-yet tested this code at all, but I do know that
> disabling ASPM L1 on these NICs (using setpci) fixes the hangs that I
> have been seeing on my Supermicro servers with X9SCL-F boards. I hope to
> get the chance to install an updated kernel on my two afftected servers
> later this week.
>=20
> Chris Boot (2):
>   e1000e: Disable ASPM L1 on 82574
>   e1000e: Remove special case for 82573/82574 ASPM L1 disablement

Thanks Chris, we are going to take a look over the patches and Jeff
Kirsher should apply them to our internal testing tree.

Please let us know the results of your testing, we will let you know if
we see any issues as well.

Jesse

--Sig_/_GqVr+9M/caExEfma/f495s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQIbBAEBCAAGBQJPleGgAAoJEFi+OMPmMDUeSNUP+Ii9bDfh3tR9tSrzW18siof+
hhzeqsMCieSXFUdEEVYJBb/R9EHFVU/KJ09Nw/mNgU7F1hQOcvfxxFkgJrKzWCes
9eqKHksn5x3xxDO5vVd799i+yc01RU7pb5D+IXYH2S+kWkGYuQs6NDOj513gtZso
ablX5SPE/WvpxXlRwQa6l8eQskwZO0l9bNjD7KirawPj4+DAt96QWrTY+wyiJmG1
XySJxWor9zQiCq02sEjBRh6tTX1kHsGT439yKXzqDyDND8BWmlBD0M6W0jpFwcWL
UhvYSV6XVgR7KQdlfMkWKW1uRvwMQtMBmWnXP2fUMkNiOYb49VbnXf087pl2Z+vK
qcubjq6S65tYZSgOUJ0drTn7h5L1nlp016r0pzHQWlh6+hhySkLcrjU27a7DTckx
1odkZMSkzttABmFJXvoQ+Eji8KIuu4tM/zxAEOnZqysFqWqc12FPs6J0XHxcnrNo
pxts3+xDR/ZPGJw6lQCKQiRYiDCWgApFGBgF+OW7KN+QMB1CDBAs9IGE0CJjTqD1
8ZUc4myGBFDinQ8nzIy1rS2YSMw97fNtpzv/6ziwMAA/7URxpOjvAmT4oMzsVEJj
/UP/GdpvjakdcZ5DBhQYEvoa58eShuNEdft5SobKIc2RdqONuPb6/QwmirAVNwMy
LW8wLAIlpaATr91vAo8=
=TiZl
-----END PGP SIGNATURE-----

--Sig_/_GqVr+9M/caExEfma/f495s--
