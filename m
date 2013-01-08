Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3AHNPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:15:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab3AHNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:15:53 -0500
Date: Tue, 8 Jan 2013 14:15:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH v4 RESEND] pwm: atmel: add Timer Counter Block PWM driver
Message-ID: <20130108131548.GA28676@avionic-0098.adnet.avionic-design.de>
References: <1355994776-4764-1-git-send-email-linux-arm@overkiz.com>
 <20130108071023.GA2171@avionic-0098.adnet.avionic-design.de>
 <50EC148C.7080304@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <50EC148C.7080304@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:p6Pi5f1g26cf6Songd1D68O0JPcIPslgBFIwPummT6q
 JqWwD9yJDsbee/2cbsjRWgMfHRPPdXuD1gMT5bqScOjcpsqJeD
 P0lrLPqUhn4k1pRCcTyfb17zANV17084yLXIlghi3BDLwwLTGs
 ntHcNK2qac+MPIXlSX8+e+4+wWfPblVe7yC2mjxIO5WqC6JEeP
 fMlempQj2lxj2iVppAASIQ23Kqu8Rf+6CKtzVoil7xIEU9rEjN
 k6s1WUnGEeR23qi0vFIadQEEGbPb7N7x8UKTP/2V6dVZiceRC8
 dQHZPRvUX06olekKLh4nuW/1VgmOkWdVhQx8Yafml624dj0W+8
 4LztMV4ZxlFPjLVM7Ag6os1unI5avXiu/ybr7lcHaOmsY/Ya2q
 erDx9qigECAw1axePLRbL+Byg0kGu1ZWl1/RkkVGCgUCxTuDm4
 TtNcR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 08, 2013 at 01:43:56PM +0100, Boris BREZILLON wrote:
> On 08/01/2013 08:10, Thierry Reding wrote:
> > On Thu, Dec 20, 2012 at 10:12:56AM +0100, Boris BREZILLON wrote:
[...]
> >> +static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_d=
evice *pwm)
> >> +{
> > [...]
> >> +	/* If duty is 0 reverse polarity */
> >> +	if (tcbpwm->duty =3D=3D 0)
> >> +		polarity =3D !polarity;
> >=20
> > Rather than commenting on what the code does, this should say why it
> > does so.
> >=20
>=20
> Is this an acceptable explanation ?
>=20
> 	/*
> 	 * If duty is 0 the timer will be stopped and we have to
> 	 * configure the output correctly on software trigger:
> 	 *  - set output to high if PWM_POLARITY_INVERSED
> 	 *  - set output to low if PWM_POLARITY_NORMAL
> 	 *
> 	 * This is why we're reverting polarity in this case.
> 	 */

Yes, that should work.

Thierry

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7BwEAAoJEN0jrNd/PrOhul8QALWiwSbcS3oqRZdID+UGXJwv
20CeTIxqY607pXcGdt/aKHjlQcRjTvK9yj0ZD6314Y616pFf4v6AFjK3a/tDpwD2
MsS+MoSPiBJRPraR1D4zU0/YAHysy7O9F0LdVph6oQBXLSyG5rY+38hAXh2Ip3Lc
KS912H8KQys0iGGs6EEeiRNDL07u1F+s/ZMmW0IdHraAmlNp1yurC7QSPP/03mM3
zN1B67AjmBcefiuc1CeAN/wCMVUvRkH58T4pzy3QT8DDSv7djhBQSRYypC6l9BW/
i5wTx62G93j67BFbi9sTAiDZEu6kqR1SOfmx/eLQ+OToYZPMG4n2fKWDxeMLIzpn
6Z9yNh5/bHaHGt4kRvm3zOzV42ybZl1PqhWdTsyTQSMZJN7nrHf2vyhCC7wtaOhn
ZhL7izAPMaampYEIJakIC6o5MYxnUvlTK6fbQ28kbbtv+Wa8ujhY3EPOtKN/WTF3
E3tQUUQOzqs8pGsFuRzY3Efw1M5nsRQhmQMbRzZhEuZU5Zqd90MAsFas9D/tY4/w
SvOpgLykAWmf7gty27KRIKpKSa0CCkjxbAOcUNjPRzFvuUKYCLMIMDpD+wmwEJ7Y
mYvJVfM8YrIZpJQt52zovKelv7NWwyHHldytRpED6yNa8/eTmt1jTRqEt/TvdCWO
BHyUYlAMghrG3N8ixaB6
=46D5
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
