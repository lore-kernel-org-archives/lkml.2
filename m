Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1LLVkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:40:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab1LLVkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:40:17 -0500
Date: Tue, 13 Dec 2011 08:39:59 +1100
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/4] fixes for twl4030-irq in mainline
Message-ID: <20111213083959.5f280d71@notabene.brown>
In-Reply-To: <20111212173819.GT13952@sortiz-mobl>
References: <20111126201334.16080.85045.stgit@notabene.brown>
	<20111212173819.GT13952@sortiz-mobl>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W70SlupZFAfyC8J+mUW=8Ug"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/W70SlupZFAfyC8J+mUW=8Ug
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2011 18:38:19 +0100 Samuel Ortiz <sameo@linux.intel.com> wro=
te:

> Hi Neil,
>=20
> On Sun, Nov 27, 2011 at 07:17:41AM +1100, NeilBrown wrote:
> > Hi,
> >   The recent tidying up of twl4030-irq seems to have left it broken.
> > At least it doesn't work for me on my gta04 (www.gta04.org).  The
> > first interrupt from the device freezes the whole system (by being
> > constantly delivered)
> >=20
> > The following 4 patches make it work for me and addresses some other
> > less critical issues like a typo in a comment :-)
>=20
> Thanks, I applied all 4 of them.

Thanks.  I have a couple of other twl4030 patches, these ones related to
battery charging.   Hopefully I'll be ready to post them later this week.
Would they go through you too?

NeilBrown

--Sig_/W70SlupZFAfyC8J+mUW=8Ug
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuZ0rznsnt1WYoG5AQJ9tA/+N1dkGyBPR3Kj6Oh+aV07N+yLpCr1WVAx
WBUgEm2sc7WFJfc9YnJY1YYm0xAtuyn7LPdZG1be3EmRoMKPrcWEOIe0Y4ijwqhF
/dfeyZOVNL4NvJm6Jg+Dbt6gIoj9PYNj1L4DiBimxEMLvtbjZaVW51JDe32yAQ/+
te4jODpM7XkczctRmQQTdFWetYqms6Tzx6hwWB1q0mA3F1aeQP6BchN57hcelaQC
Wf9oTkZSaJJxsergr/PnZGKJMjQjMFe78RyBDWFoVZ0gcxqnC8vPKyTpGyiYacsE
rhVoXhsXmpoVO2aJSFxnuwdhXtxirR56v1TpaMCF5TX4e4qsl2r1dot2R6x84Fs1
hkNVhhc/aHOw0wp1b+Re4rJlwdzYUvzIJ5S6ktb5g6SkpWZLUHq+RNq/8DLAeaci
Jr1ubN/fjSXw1oJrwVvTNNF9MhXsU8fHpyLzN4BP3rGIbA621kB7ygQzg2IV9rNS
WSWUOlXppaxFrBBbu2UgwknIVUniRMad+YZCIzW5DcLrTqDdTAipiDS34/6+cp6h
42I0Ay5KPJENZ+UwvDt4Kl6UmGyawF2PeTfIwGaAlJNAnsjXz2lD5wKXSRDY3Fxz
MMBKOWhUskTuFU+WgvfF+u7hPxT1vtfH5WrwQlKQGmCa9WdttWyxiGA4etudBCHQ
9kC0q8FisVU=
=Culv
-----END PGP SIGNATURE-----

--Sig_/W70SlupZFAfyC8J+mUW=8Ug--
