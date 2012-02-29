Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2B2L64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:58:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55231 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2B2L6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:58:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.50.236.34 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330516879.3545.103.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: tglx@linutronix.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Date: Wed, 29 Feb 2012 14:01:19 +0200
In-Reply-To: <4F4E0E9D.7090002@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	 <1330515322.3545.99.camel@sauron.fi.intel.com>
	 <4F4E0E9D.7090002@linutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jFegWjEazJlIbKQhlAa1"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jFegWjEazJlIbKQhlAa1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-29 at 12:40 +0100, Richard Weinberger wrote:
> Am 29.02.2012 12:35, schrieb Artem Bityutskiy:
> > On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
> >> The following patch set implements checkpointing support for
> >> UBI. Checkpointing is an optional feature which stores the physical to
> >> logical eraseblock relations in a checkpointing superblock to reduce
> >> the initialization time of UBI. The current init time of UBI is
> >> proportional to the number of physical erase blocks on the FLASH
> >> device. With checkpointing enabled the scan time is limited to a fixed
> >> number of blocks.
> >=20
> > Notice, your patch-set has huge amount of checkpatch.pl complaints -
> > please fix them. This will also be consistent with the overall UBI
> > coding style where I honored checkpatch.pl limitations like identation
> > style and 80 chars per line.
> >=20
>=20
> All checkpatch.pl complaints will be fixed.
> But first we have to discuss and address real problems.

Sure, I just to not have time to look at real stuff now.

But yes, I assume you will come up with a good way to stress-test it.
You will look how the unstable bits problem affects the checkpointing. I
would suggest you to implement power-cut emulation in UBI just like we
have it in UBIFS, then run the integck test which already supports UBIFS
power cut emulation. This will allow to catch a lot of issues.

--=20
Best Regards,
Artem Bityutskiy

--=-jFegWjEazJlIbKQhlAa1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPThOQAAoJECmIfjd9wqK0GHEP+wXJSq1/U/5sj22cWL+zjM4q
XPzOB3pd0E9CMnqq17DMt+zC9qmGvYn0f+v6LC0x3NbI2eKt/jhrQ86I6u9OU8NL
k5bZkq512yk0sC6i2uE9HI1dTi8mrFuwNvj6CnHYI9ap6BNMrROmsA3M7r4anajF
ie+8+LNu5Ekb+3K2IniZQCxcoEsoN8wh2xgoBeDYxmy+7nrXjCdyRXYv6oXetcUj
HJJpGrGUyrqeJN2R0G5SsTFvcMbPicEpSZBuhgw087l8S9gNvOmaqKkoE0yYzMso
SqjsjXTWYLrGtgJ6Nc+rPvg+oOU7FcOvT3JW9b3TGSYmM+xFLKM+iLKzbJTi2BWh
FcwwR+8GbJNNUcktF2aMR2XnYdVacaZruVNhTxj85dUeDMCD5iDp9OolZgHpFdDv
4kqFJ68B28sJ9uZnJjvWl62JWsZ3hV39r6JD+9QS4GvZMIkLdOhHWbmO+rWi0+C5
PFkqZhdRsat4Fm3ffsodRq226VGc/HVDg8uqS5yUjIAdO7jflKo3IrHJepqI28U+
0OCSKvYEkxcfmO8mKi9FYok1Go+oJ+P0CM7gzK9OOtJyx7WccrbqWnfrf1FaozQv
/1N1J7r7qgA9PvrSwau4pKNeVFok8TBCDNFOatgNvBcXHPu53F1NacBG15iuxKLU
VcUagiunmeREWO6Mt2r4
=BjHj
-----END PGP SIGNATURE-----

--=-jFegWjEazJlIbKQhlAa1--

