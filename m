Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2IXGt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:49:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40201 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2IXGtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:49:24 -0400
Date: Mon, 24 Sep 2012 16:49:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>, Len Brown <lenb@kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the acpi tree
Message-Id: <20120924164916.faeb0225ef2b0732762d8aac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_16_49_16_+1000_rq22=mJCDKfLwJ7n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_16_49_16_+1000_rq22=mJCDKfLwJ7n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/core/usb-acpi.c between commit 59e6423ba8aa ("usb-acpi:
Comply with the ACPI API change") from the acpi tree and commit
05f916894a69 ("usb/acpi: Store info on device removability") from the usb
tree.

The latter removed the function changed by the former, so I just did that
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_16_49_16_+1000_rq22=mJCDKfLwJ7n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYAJsAAoJEECxmPOUX5FEvgYQAKJD8yYyRxtLlHZHhGpjWyjy
ns33pkpQ/mne0nQux/h7mh9874rY9KmTv+6uqofWfroYTYzc3xRE8aJ/2HJ1bIDx
FBzmcga2q0ysxzoDLpUiuKVhGLfJytI839KRmRodHLX/iKdqtmheuUpU5pqKpG/f
iyuyU2xBA0AzXwcPrsqqIh5aE489N+gm8hqP4h8QyHeOv65u6dMPmQ/D7i2OY4+E
isBoRzpAgnba2kWe80i7g8e/9LobB22fVj484v0NLJj3HNY0RCXUCqnj9/bNu6a/
mX3pbzilJ6FWbQR/64eJtjpIfRPxFcWNGT7/Y2GRDXUZk6BlU3jiz2VOtlEP1nm9
l+FDnd+5Vnhb+SscRfcQJpu3F0ejSBRM8M8vSGJXpsC2d9VfhV9XY1DCoxeEfcnr
BWq8taVsRUwTDRRkSL3BKFavK0CcKEgpqdJi/7II99suGL1M1WldR2pftAtqJB00
JaWWP1yoChprqdUpHEWV3z89JqgV1RioAam8gqBRJzWLmsm6gKpEUM9s0bxnlIL3
DIKOlrMm16HStBaXLYXCJf8wQkWmGYV/QgpZs+Sl342XPxAhch4go5wM/YgkTd/z
K7hsSBuDtX2CRtiLOzKuAaI+qPXuSb3Xxt840+ZH3tq/XjBdYuRnl2jRCw3YzDM8
e5X4/ttCGJMd4R+44JkS
=UoYj
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_16_49_16_+1000_rq22=mJCDKfLwJ7n--
