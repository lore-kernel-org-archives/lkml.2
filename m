Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2EIDDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:03:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37509 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789Ab2EIDDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:03:39 -0400
Message-ID: <1336532605.8274.339.camel@deadeye>
Subject: RE: [ 73/75] iwlwifi: use correct released ucode version
From: Ben Hutchings <ben@decadent.org.uk>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Wed, 09 May 2012 04:03:25 +0100
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD1531EC@ORSMSX103.amr.corp.intel.com>
References: <20120504204230.580609792@linuxfoundation.org>
	 <1336401714.8274.320.camel@deadeye>
	 <4595B4D22AB93C4FABBA84AAD5AA37FD1531EC@ORSMSX103.amr.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FNDakiU0liqQ2h65/zWo"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FNDakiU0liqQ2h65/zWo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-07 at 19:24 +0000, Venkataraman, Meenakshi wrote:
> Hi Ben,
>=20
> >On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> >> 3.3-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> >>
> >> commit 78cbcf2b9dbe0565820dc7721316f9c401000a68 upstream.
> >>
> >> Report correctly the latest released version of the iwlwifi firmware
> >> for all iwlwifi-supported devices.
> >[...]
> >
> >Isn't this also applicable to 3.2.y?
>=20
> [MV] Just checked -- it is indeed applicable to 3.2 stable kernels as
> well.  Do I need to modify the patch to get it into 3.2 as well?

No, it was easy enough to fix up the context.  I have now queued up:

b914811524fbe9e91fe50845f5d7bd4316b8a6ee iwlagn: allow up to uCode API 6 fo=
r 6000 devices
78cbcf2b9dbe0565820dc7721316f9c401000a68 iwlwifi: use correct released ucod=
e version
1ed2ec37b44e86eaa8e0a03b908a39c80f65ee45 iwlwifi: use 6000G2B for 6030 devi=
ce series

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-FNDakiU0liqQ2h65/zWo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6nefee/yOyVhhEJAQqqXhAAuOBj+YbGiJxVZzNG5Rlc432yh1I2SBa7
nRwGwHD0ibBsNrOrwTyRbSKhSQ7Mbt/T5chL76Ee3K23pfZctqcqD86i7c64FYKE
e0m1MUTpW35nylUJShUWtadAoCJ8VH6k7PuIp/wKyNHYpjp8sVB28Se8PkE7nuwp
1Ktl1fycwCl/ztQr9DhF4beTay6pPrUPcbXBv1hG4AMp28CXJEXVrt7E0y+sztXm
V+Ve1RRNK3Wu3ixidMRnE6LLrVCfqKJtTnOcUJieAzOke1Ci3e12jHyogKUJr6h3
fR7CnpIwbWOuHNhlyj6COliIo+ntaQalYJNQnc0FobctP0tyb4kl3M4SgZDt7MVi
Z8MPuhYFKPC5PG0dheppyYQFkzdGMYX5hqRTOrYEfIYi0IvjGvXt+jHg0hjoWY7Y
TcuwB1vv2pNgdExRO2Qe4AaDSckqPwlvgrS6mkeRMYAxWUC524x6N2WPuAqBy0N/
CqMfKJnPxcOna2fLncm7hyy7hWChh3p1QWyribmFqtLvUlZe6FMC++NLLUwLk+iM
VQtgOBtWBPpEAcqIT4Dd978kGpTXrFY5f1x/NXbydaE8IyfeMLpB7XoOJvohUTGI
NNP8qcmPUejxqFNqYVjhoi3sAYFtlcdPSbO/yqPOJvYyObDdfQTbg6H5ngoSgp+i
zohER/Cnkcc=
=lJKe
-----END PGP SIGNATURE-----

--=-FNDakiU0liqQ2h65/zWo--
