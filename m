Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2LXQLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:11:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42951 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXQLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:11:10 -0500
Date: Mon, 24 Dec 2012 16:11:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 13/25] sound/wm8350: don't use [delayed_]work_pending()
Message-ID: <20121224161107.GQ30837@opensource.wolfsonmicro.com>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WjWU9mUuKzTKEtBb"
Content-Disposition: inline
In-Reply-To: <1356141435-17340-14-git-send-email-tj@kernel.org>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WjWU9mUuKzTKEtBb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 21, 2012 at 05:57:03PM -0800, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.

Applied, thanks.

--WjWU9mUuKzTKEtBb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2H6VAAoJELSic+t+oim9WHgQAJ5qm7mWdFbhl/NMLJlwSYuu
BSwUxmEL1MgR/Hh6fV4fgUXWqboyMsETv9gYY485k5io6Jx1StaaGauYjkiiCB+4
f/ePO8OXE13eMv3PKzOZ2pzgIXNsvCOSUvM4vxFAAv1y+iy4xFicNAuiZqKI1FdH
uwAYdHjzBD+pNWDNF+r+H2H67EPG+bVhdZDYPEKed5uRintw3YxEJ5Qexqyeps20
Yh6zVk+SEsCSRfdjegXogB2cbifSp0SbpumpmjOOaaWymct3eteJiocEUTCHScPf
gLGoDaE5bPJsnCwDwfLieFjvxUtkgJ7gcOO/CcDi4xTCY6kYXbQFJk4k7ocxnSlG
wbIjaDsCibt/h8RGVrQnh1LOE37m/Fu6IKyIemIvdV9/6bO7WfuzS4sm+jlzvKdM
IgtyUI0YlpR5sfwvOUHY8yNTCaWm6NIVUQRyWnrVjrsAWdoOCxt94bxqtZ25HVRG
tq9UaeutFUL0PsBKsjRIXU4K0R82xaWoMUMSKBi4BgQIGCp/J426fQYzANRoOv3Q
gnfQHaGuG6HRE4zroO0Jz+lWFv8cOPI58duWHlxUGL5l6xUS8fL0I1oShj7nwY9u
MHPkyQ/QBoNXQ2D/PiXu/qaEgWKMdYtX7BcAZfXa6AAmngsgBkeKplqQLDeVtvoA
fZb7+opIONXj4+dWOB9d
=n2u/
-----END PGP SIGNATURE-----

--WjWU9mUuKzTKEtBb--
