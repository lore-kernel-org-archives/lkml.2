Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1FSTB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:01:58 -0400
Received: from home.keithp.com ([63.227.221.253]:52272 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1FSTB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:01:57 -0400
From: Keith Packard <keithp@keithp.com>
To: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
        marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key requirements"
In-Reply-To: <20110619175937.GA24188@dell.ger.corp.intel.com>
References: <yunboy7a2so.fsf@aiko.keithp.com> <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com> <20110609083345.GA2894@dell.ccr.corp.intel.com> <yuny61b3pnm.fsf@aiko.keithp.com> <99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com> <20110610055558.GA1832@dell> <BANLkTim4F8ZvWPMHSXpcBj9Eb2uFThcz4w@mail.gmail.com> <yun8vsynkiy.fsf@aiko.keithp.com> <20110619175937.GA24188@dell.ger.corp.intel.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 19 Jun 2011 21:01:40 +0200
Message-ID: <yunliwxabmz.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Jun 2011 20:59:37 +0300, Johan Hedberg <johan.hedberg@gmail.com>=
 wrote:

> I think you'll need both of them to fix the pairing/security issues.

Yup, with both of those patches, I get syncml and dun working again.

(sorry for the delayed testing, I'm traveling)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN/keUQp8BWwlsTdMRAm0HAJ44h1GTyPKILM0gaxQz9fa0HtvxmACg48Rs
v4TTnREemuN/1jzKOtfTfsw=
=agQ6
-----END PGP SIGNATURE-----
--=-=-=--
