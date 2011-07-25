Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1GYSYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:24:55 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:60546 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1GYSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:24:52 -0400
Message-ID: <4E2DB4ED.4070505@web.de>
Date: Mon, 25 Jul 2011 20:24:45 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
In-Reply-To: <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
X-Enigmail-Version: 1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D7153CCFAEFE868E9326C99"
X-Provags-ID: V01U2FsdGVkX186YadHdp2R2QuB+xt4FG3HxGOw2DorcMwBsznc
	1J0G8Oyd6CbvRRlbw+sISLdVoSKq4b/4O1cdZ6oe8ESTOXwEV1
	XTD+8TgCg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D7153CCFAEFE868E9326C99
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2011-07-25 09:37, Pekka Enberg wrote:
> Hi Jan,
>=20
> On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
>> I've read several times now that developing in a single tree leads to
>> better results. Can you provide some example from the QEMU/KVM project=
s
>> where the split is preventing innovation, optimizations, or some other=

>> kind of progress?
>=20
> I really don't follow the Qemu project well enough to comment on what
> your biggest pain points are there.

Mmh, you can solve problems you do not even need to know about, just by
merging them into the kernel? Wait, will send you some more! :)

>=20
> As for tools/kvm, it's pretty obvious by now that we want tighter
> integration with perf and the tracing facilities (and share code!),
> for example so for us merging to mainline is important.

Tracing&profiling are important topics, but in the end just small pieces
of the virtualization problem space. If that was the strongest reason,
it would be like asking gdb guys to merge qemu because it contains a
gdbserver.

Anyway. Thanks for all the fish! Found nothing new, not much concrete,
but many really entertaining answers. So why not repeat this on the next
merge window?

Jan


--------------enig7D7153CCFAEFE868E9326C99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4ttPAACgkQitSsb3rl5xRRzACdGjY227PblNbucp7Mut3mHXud
HqoAn2Ob3IubD5RSCSR5sKi/2V/PfCCd
=w3P0
-----END PGP SIGNATURE-----

--------------enig7D7153CCFAEFE868E9326C99--
