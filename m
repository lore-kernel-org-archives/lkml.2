Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2HPLxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:53:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:25093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab2HPLxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:53:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="asc'?scan'208";a="181760619"
Message-ID: <1345118285.3393.217.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get
 bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 14:58:05 +0300
In-Reply-To: <CACQ1gAi+dDFBrLM0-cVAsFu6_7B3=ij9Lqm3W+SHCxTRSE9kww@mail.gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
	 <1345043331.3393.151.camel@sauron.fi.intel.com>
	 <20120816112507.01b7c0f0@pixies.home.jungo.com>
	 <CACQ1gAi+dDFBrLM0-cVAsFu6_7B3=ij9Lqm3W+SHCxTRSE9kww@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-2ZtV2knUQJpb0XcOeMMq"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2ZtV2knUQJpb0XcOeMMq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 12:35 +0200, Richard Genoud wrote:
> Ok, I'll change that, may be in a separate patch, as it's a bug fix.

Let me take care of this patch. I'll amend it myself, push to my tree
and re-send to the mailing list for your review. Please, provide an
updated version of the other patches instead.

P.S. Of course, your authorship will be preserved.

--=20
Best Regards,
Artem Bityutskiy

--=-2ZtV2knUQJpb0XcOeMMq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLOBNAAoJECmIfjd9wqK0WPoQAIbo/6e1nskfPYlgMJnGdtTn
O1icu6Xvo5PduRn75b4rbieT8YmC9i0RzuaPsbm+v7syMMgZ8fCmW4hG+KLUG+KR
P1qvc5Vv+5P7eVGH6kHhr45A4g72TPblb7GSzi/2CbH8csdW9OHuJADcGO+GefzH
iaveyspZktV8n5pKLWKwHNDSL3hopJ/olSDDW84cU+NJ2euwRVJSf7vVmeBLwq8d
7KgVb0LUG6JIEYL/cfabzMpSN+0F65sL32C6aU3TbJ4GN9iAD6PZ11YN7kCh7UFk
NqYprcjxspUYa6puV7QeObLsJoTHztJyNougmjmdrXEyEbD5VfLpse4XT0+2rIGi
B/AYnTGDveYyp5E6eeZuC7EhgKFW0wR/fev//sgdbHEcPLAmydPGIXAoR2vud3bQ
cw3M8wl7E+4EOHIyfXBPNWa9QtxcmgN1hYrCPApQgfyJ+uiTKu745kNRxi7Gaa9d
irIxAcLpNn131MlTtMNPS9nyq1by7vN/WxBlS95jFTsJVC01UkKrYFB8/KQOgYdk
I8+4aJuxxz29nQ8ynPGBxKNU75eeGulO2e76mMHI/mtc6g6+RwjxS/r33HlpgxQz
LL3jXoL/TvwgnErCaUePOLD6OBtl0HkbapcDrPNZsQ624PWLLAVCN4XqFbBbN8Na
Xn2twOmeTwgSL2Ecyb9f
=i6jo
-----END PGP SIGNATURE-----

--=-2ZtV2knUQJpb0XcOeMMq--

