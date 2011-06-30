Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1F3Jam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:30:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46207 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1F3Jaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:30:35 -0400
Date: Thu, 30 Jun 2011 19:30:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the security-testing tree with the
 tree
Message-Id: <20110630193023.6056d48e.sfr@canb.auug.org.au>
In-Reply-To: <20110630072559.GA4048@pengutronix.de>
References: <20110630142910.2fea4257.sfr@canb.auug.org.au>
	<20110630072559.GA4048@pengutronix.de>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jun_2011_19_30_23_+1000_FPHb.q8Ju=toAu/n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jun_2011_19_30_23_+1000_FPHb.q8Ju=toAu/n
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

On Thu, 30 Jun 2011 09:25:59 +0200 Uwe Kleine-K=C3=B6nig <u.kleine-koenig@p=
engutronix.de> wrote:
>
> Long history short: James probably used -s ours or similar and it's fine
> not to merge that commit into next :-)

Ah ha!  Thanks for the explanation.  My mind was clearly not up to it
today. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jun_2011_19_30_23_+1000_FPHb.q8Ju=toAu/n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODEIvAAoJEDMEi1NhKgbsaZUH/i64CxxpGaK5mgQXAs0w+dy3
zg+QMPOvWlztgiJxPSAHTghGcr1sZaeSUZA1qyWGjrt+FQ4mnAjX1UH7JYXTonav
BaQyXJuVyNQ5Y/EXpIgkRapttS0ExRwBrxPyxC32WCFAD1yqYOlgA15L8yC5RzdY
zIWBnRaF7pfPMQKHE+bSAf7YZTtL5FDTOhnhi5uYP85tPQJo8KTmiic7gAhrBDAC
PLf4ZQbtzXtOmSgpz0CwPWNqG16GBJUYLfwmBCQ8m6gdHIjR1IX+5pXrnWQtyWEy
6qu9mvW6N23QfeDLaafbjNR1gyQsm3WeyXPrKiiMNEyhOsaldkxWQMf7/rbuMJE=
=jEb5
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jun_2011_19_30_23_+1000_FPHb.q8Ju=toAu/n--
