Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2FSD5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 23:57:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36011 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036Ab2FSD5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:57:15 -0400
Message-ID: <1340078223.6871.5.camel@deadeye.wl.decadent.org.uk>
Subject: RE: [ 39/69] iwlwifi: disable the buggy chain extension feature in
 HW
From: Ben Hutchings <ben@decadent.org.uk>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 19 Jun 2012 04:57:03 +0100
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB316D631@HASMSX103.ger.corp.intel.com>
References: <20120617175941.281333656@decadent.org.uk>
	 <20120617175946.829354534@decadent.org.uk>
	 <20120618191853.GB3263@herton-Z68MA-D2H-B3>
	 <0BA3FCBA62E2DC44AF3030971E174FB316D631@HASMSX103.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wPlSorvSLST6EHY6Up8W"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wPlSorvSLST6EHY6Up8W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-18 at 19:23 +0000, Grumbach, Emmanuel wrote:
> > Hi, this triggers the following build warning:
> > linux-stable/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c: In function
> > 'iwl_trans_pcie_tx_start':
> > linux-stable/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:874:2: warni=
ng:
> > passing argument 1 of 'iwl_write_prph' from incompatible pointer type
> > [enabled by default]
> > linux-stable/drivers/net/wireless/iwlwifi/iwl-io.h:72:6: note: expected=
 'struct
> > iwl_bus *' but argument is of type 'struct iwl_trans *'
> >=20
> > For 3.2, it should be passed as bus(trans) as other invocations.
> >=20
> > >  	/* Enable DMA channel */
> > >  	for (chan =3D 0; chan < FH_TCSR_CHNL_NUM ; chan++)
> > >  		iwl_write_direct32(bus(trans),
> > FH_TCSR_CHNL_TX_CONFIG_REG(chan),
>=20
> Correct

Thanks both, I'll fix this up.  No idea how I missed that warning.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-wPlSorvSLST6EHY6Up8W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9/4j+e/yOyVhhEJAQp0dA/9HSTrXtU+DSqskzPt89KSEsBROrB8go6J
SNtlLFk+KTVgKfRO/Q+JuW8U4KBjeA5VpY3fhhBu/8e/R2Ym57FQYsp3EzMHUQW1
jHnoQP9IW3I7LOEtbaMZt4qfMQwy0lLKQi6qPR0gSxzHQsOnjoz1rbbNNdLRtEjv
jS567EN5tMjJ0zb9Fp807B58J0X6wFx3u8ePtCcn/qdPW/aOJVhD+45l87fHFIIA
mv6PsPRVD/Gyl93qsi5JYN4DCGjP55tygXD/F8cNdbkqle/92jqP3Q57zRswhYUQ
X7bRmrSXPP/fs7vOVaB7/3g5IFsykqRTdi9zmhpfsxbU7zAGp63IT9NKs4tG46ci
mt9fVQAiLWhXj5gX5Mkwh3bBu/YpRZJ8RZUc6H4oFL7dz2TjDFf3i6ycxJn3LMiF
/4TPyPGln1BtFgip4VpurvJFrJklySYm6S9LUgF1SXkofS1tY36Ku833ZrNRDctd
ZxQpsPR0UjVEJXdJV5EvlRGkLdJCRZt2mzyP66t+qqja2/Ry3uzB8YfWOcKnkg1q
wIpD+HpvFU5OOnUwZYnpbBAjql9CMhUucR2iQuHbauiewjzCvF7ZlSCR2JwxQnKE
CAiPmonpmfGpaW3zR6JrxciUI8YecqXeBanXvIVwxA/1xeOdQbw+JRvnCISUE7dw
4STeFk0JMh8=
=fW98
-----END PGP SIGNATURE-----

--=-wPlSorvSLST6EHY6Up8W--
