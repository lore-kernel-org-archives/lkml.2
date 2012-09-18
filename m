Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab2IRKvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:51:46 -0400
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:34370 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756633Ab2IRKvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:51:45 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2012 06:51:44 EDT
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.80,442,1344204000";
 d="asc'?scan'208";a="192143379"
Date: Tue, 18 Sep 2012 12:21:41 +0200
From: Carsten Otto <otto@informatik.rwth-aachen.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Alex Hung <alex.hung@canonical.com>, corentincj@iksaif.net, mjg@redhat.com,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        679158@bugs.debian.org
Subject: Re: [PATCH] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.
Message-id: <20120918102141.GB4118@daedalus.informatik.rwth-aachen.de>
Reply-to: Carsten Otto <otto@informatik.rwth-aachen.de>
Mail-followup-to: Jonathan Nieder <jrnieder@gmail.com>,
 Alex Hung <alex.hung@canonical.com>, corentincj@iksaif.net, mjg@redhat.com,
 acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
 linux-kernel@vger.kernel.org, 679158@bugs.debian.org
References: <1340164055-1062-1-git-send-email-alex.hung@canonical.com>
 <20120626213958.GA17871@burratino> <20120626215806.GM21479@carsten-otto>
 <4FEABBFC.6090708@canonical.com> <20120627221743.GC13738@burratino>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=eJnRUKwClWJh1Khz
Content-disposition: inline
In-reply-to: <20120627221743.GC13738@burratino>
X-GnuGP-Key: http://c-otto.de/pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear all,

the patch seems to be integrated in 3.5.4 (current stable kernel). When
rebasing using git I see that the patch is not applied on top, most
likely because it was already included somewhere in the official stable
Linux itself.

As mentioned in the following Ubuntu bug report, this patch causes
problems (which I also observe).
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1041883

It takes me about 10 tries to successfully boot my system. In the
unsuccessful tries the screen is blanked shortly during the boot process
and nothing happens (the magic keys don't work, network access cannot be
tested that early).

Bye,
--=20
Carsten Otto           otto@informatik.rwth-aachen.de
LuFG Informatik 2      http://verify.rwth-aachen.de/otto/
RWTH Aachen            phone: +49 241 80-21211

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBYSzUACgkQjUF4jpCSQBQpbgCfSUUvaZbs1krkcRKa8iTcyKxA
7AQAn1NfXugZ5553+Z9LOB46lJqFcXt8
=avwS
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
