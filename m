Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2EZOPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 10:15:50 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54305 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab2EZOPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 10:15:49 -0400
Message-ID: <1338041744.2525.46.camel@koala>
Subject: Re: [RFC v7] UBI: Fastmap support (aka checkpointing)
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Date: Sat, 26 May 2012 17:15:44 +0300
In-Reply-To: <4FC0E257.1030403@nod.at>
References: <1337771191-95358-1-git-send-email-richard@nod.at>
	 <1338036094.2525.7.camel@koala> <4FC0E257.1030403@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-20S/G86t3TDymXYh5elg"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-20S/G86t3TDymXYh5elg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-26 at 16:01 +0200, Richard Weinberger wrote:
> > We can start with the UBI tests from the mtd-utils plust the integck
> > test. And whatever goes to my branch should never break them. Do these
> > tests pass now? If not, let's make them pass.
> >=20
>=20
> What is "integck" test?

It is a quite extensive FS check which we use for UBIFS. As UBIFS is the
main UBI client - it makes sense to run it. It lives in the
mtd-utils.git/tests/fs/integck

./integck -n8 /mnt/ubifs

would run in. /mnt/ubifs is the ubifs mount-point. -n8 means repeat 8
times.

> UBI tests from mtd-utils pass now.
> The io_paral triggered a race condition on my very fast qemu-kvm test sys=
tem.
> On my test board with real NAND flash this race never happened.
> Anyway, it's fixed now.

Cool!

> I'm mostly testing with custom scripts, shall I send a patch against UBI =
tests?

Yes, it would be great to integrate this, of course. I might also want
to send you a patch, then I'd run it.

--=20
Best Regards,
Artem Bityutskiy

--=-20S/G86t3TDymXYh5elg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPwOWQAAoJECmIfjd9wqK0ZCgP/3mqtNa+nR8Nz2IQjh2Nh4mE
HPzE9EHSOlgglKFqe1Dn2FZptU9rjqYJQrGXkRztc4mtHHnEfRgjVdDim2T/e6RV
xycI00Nj99Nv4kRiNV9vMSo7Bq6t6ekA0JXRkMx/UbXaHBnes8HOZGXxW/cCHc2s
R8WfWB2X8S9VcdnE3iEZLFrdCmEvs817OymJVSTxeO0M0/qYBnDkEND7PMx7JZ1P
OlIKMaXopQ7Ubc7FKPd9TkqA0h3hx98L7r7BLox7rFzA9mwgTTpKyoH7XEIMMnoj
JDMXxsSUtmuuDA9HDP6alSbL9OvVqczJ/OLirqw7VB9gTDZgtndM9koK7po1GYiy
LAmkZdAv2q8ga8Dfi1ACZpS1uI6EfGenNnGstFhDG6NGcoL42ZN1C3loR7/SbdcZ
6CptR+nXgyWbTRwf28bt0L4virMGHRaleAiP5Cps7zVkyqSmoAp9BnuPuB9dtC9L
C6YnlTVPKLxezgbTD6HGpHVcrBkVrwm8LlnCRBoAtUssG9M8d80wZ+lejlHl0Ugk
akgrQVUvmMEQjsE2nhMlQcmV8rWA5ZMi3ZL1LMWK0ELYjwRq0dR7sMiEAQUOuawU
ifQd5oxjrSuzj8C30O0BJT+1nilMs79mttDzcnBkJBXaoljna6dOY+igFX/8A/GK
iIYynJ1QlEsHCjHAIY0N
=/fPx
-----END PGP SIGNATURE-----

--=-20S/G86t3TDymXYh5elg--

