Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3ACHWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:22:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACHWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:22:15 -0500
Date: Thu, 3 Jan 2013 08:22:11 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bryan Wu <cooloney@gmail.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v5 0/7] leds: leds-pwm: Device tree support
Message-ID: <20130103072211.GA30631@avionic-0098.adnet.avionic-design.de>
References: <1356083041-29179-1-git-send-email-peter.ujfalusi@ti.com>
 <CAK5ve-L=L2qp1A01Kui9RAMn9mZxL7P-c0sZ1bDveLoKkK0Fzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <CAK5ve-L=L2qp1A01Kui9RAMn9mZxL7P-c0sZ1bDveLoKkK0Fzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:KB9c8E2bXcKyRabAqgyYQeDFfMFcExFcVSI5j04zNa3
 fldb4iL/DKMlMYdwPjArX2cPUujIpFiCV+imc4sSvs/iKlIFJz
 bPchVCKij8uvuFvXWn0Qaaj1gPi9tpXnQebWCq6Rp8yxdqn3xb
 9ldar9Sk4zm5/iTSl30XrfXCMRWkhz8DWS2mL0nI0YD9huNlwt
 88oOpndWzNzDTMct3GVLJBV5Pdd3oF3uGapYkaWXhZ+DSPw4Tn
 bSXuYttFh/l5otZHTROrQbPcyPIthB7yofpb3G4lsKfb3SmsHK
 I3JdXL8T8ix/z7QQcEk+HMV/1X2iuqoVG10r4CGuq1a7MvNghw
 z/ZUpL+rOwMdjr3RkagSL1c2Cz9E5g5yKiGpYzzrYwy7ZDwnAz
 cpdOymyY8WWSCP7R+CElJfvYboMqblXr4Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 06:10:13PM -0800, Bryan Wu wrote:
> Hi Peter,
>=20
> I merged this patchset into my for-next branch already.
>=20
> Thanks for pushing this.

Hi Bryan,

Did you also take the PWM patches (3-5)? I was going to add those to my
tree, but if you already take them feel free to add my Acked-by.

Thierry

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5TGjAAoJEN0jrNd/PrOhf4YP/RyWxS6KT6joLPklDPXj7r0U
Q5JkAn1ztZtZaTcSFtZQvl7i/fksbWme1hYl7vBMuKE/T/gIXJDg4zTkoOmMfuJ+
loJjB92xqPfPwcnNnPrlWTPd4tHpfTTdhv6D6e2WHYQojePcO2K75YRrsHY6bYdx
+IdkFMqcF9PWsrwJYU10w4wEAzr+khlSVaHc52qn664w4rY0TTBd1JV6YL3zAp2/
nlBFJoNyutxQ0b2we00dc60Zx6TvKvwHiPqqp6RnLekdY1ZtGBYRPXtdILY4ncaO
UKFr0Z7F1uyzIWrivPZwK2YISY1G3LBlTXOXkQ+LZMwQonbI6HiIzLTRpZdVfYst
3mevTyd9Jzc0sqlPlRWIotzdIII4R0HckDNQtiPx75l+22fnZuS0PJTnyi6tgD58
7PnXta3jw9Apw2wzMDhePa34/PsGG3K91EiQhUDHcpP0mraXo5nbi8VfCSiWtaIS
ORKc8ecWjMoedlqXeSZZhkj7UE8wCXbeWbwRcoHVaw36tguDEEPS7j+7sepAUqCE
CwkS5Cq6Bjl8TzRrW+k+Gz/N4eEqP74aCRp/aJWo4u5tVIgVWkD39bKMdSnbw2gg
2b6n0Fs/UQAohkrYjVcil50RL45u73b0KVEUFB/zxOplPMS2nRm0AEkmczSvm8MV
xKnIihA/uMxwINQb42J+
=8imf
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
