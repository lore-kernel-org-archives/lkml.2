Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab2FZW2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:28:19 -0400
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:63383 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab2FZW2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:28:18 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2012 18:28:18 EDT
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.77,480,1336341600";
 d="asc'?scan'208";a="182424209"
Date: Tue, 26 Jun 2012 23:58:06 +0200
From: Carsten Otto <otto@informatik.rwth-aachen.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Alex Hung <alex.hung@canonical.com>, corentincj@iksaif.net, mjg@redhat.com,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.
Message-id: <20120626215806.GM21479@carsten-otto>
Reply-to: Carsten Otto <otto@informatik.rwth-aachen.de>
Mail-followup-to: Jonathan Nieder <jrnieder@gmail.com>,
 Alex Hung <alex.hung@canonical.com>, corentincj@iksaif.net, mjg@redhat.com,
 acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <1340164055-1062-1-git-send-email-alex.hung@canonical.com>
 <20120626213958.GA17871@burratino>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=H14uD12u8nekTETJ
Content-disposition: inline
In-reply-to: <20120626213958.GA17871@burratino>
X-GnuGP-Key: http://c-otto.de/pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H14uD12u8nekTETJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear all,

On Tue, Jun 26, 2012 at 04:39:58PM -0500, Jonathan Nieder wrote:
> After applying the patch described above to 3.2.21, multimedia keys
> work.

To be precise, only some of the Fn keys work. I will update the
bug report at http://bugs.debian.org/679158 now. Please contact me if
you need further information,

Best regards,
--=20
Carsten Otto           otto@informatik.rwth-aachen.de
LuFG Informatik 2      http://verify.rwth-aachen.de/otto/
RWTH Aachen            phone: +49 241 80-21211

--H14uD12u8nekTETJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/qMG4ACgkQjUF4jpCSQBSAgACcCMt9vlw7LpBiTYeOg7h1BcL9
w4AAnjxUNN+IdbTMHuSptAimUerxpvLr
=fc5r
-----END PGP SIGNATURE-----

--H14uD12u8nekTETJ--
