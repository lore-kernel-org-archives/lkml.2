Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab1GXXMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:12:38 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53614 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1GXXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:12:36 -0400
Message-ID: <4E2CA6DE.4040900@web.de>
Date: Mon, 25 Jul 2011 01:12:30 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
In-Reply-To: <alpine.DEB.2.00.1107242335580.18045@tiger>
X-Enigmail-Version: 1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig58CDF04F9EFFC94C8ADF4ED1"
X-Provags-ID: V01U2FsdGVkX1+iAUtDopRiWZJVy+Wq+R54QkUTgrClrFw/hFDW
	VFsMcQVCKxTv8PppeyDLTUyJLeiSQja5l4BAWHuxTDplVXhMbl
	WHitZj99E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig58CDF04F9EFFC94C8ADF4ED1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2011-07-24 22:37, Pekka Enberg wrote:
> Hi Linus,
>=20
> Please consider pulling from
>=20
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git
> kvm-tool-for-linus
>=20
> to merge the Native Linux KVM tool to Linux 3.1.
>=20
> [ The changes to 9p headers were already merged but show up in the pull=

> request. ]
>=20
> The goal of this tool is to provide a clean, from-scratch, lightweight
> KVM host
> tool implementation that can boot Linux guest images with no BIOS
> dependencies
> and with only the minimal amount of legacy device emulation. The primar=
y
> focus
> of the tool is to Linux but there are already people on working on
> supporting
> GRUB and other operating systems.
>=20
> We want the tool to be part of Linux kernel source tree because we
> believe that
> =E2=80=98perf=E2=80=99 clearly showed the benefits of a single reposito=
ry for both
> kernel and
> userspace components. See Ingo Molnar=E2=80=99s email that started the =
project for
> details:
>=20
>   http://thread.gmane.org/gmane.linux.kernel/962051/focus=3D962620

I've read several times now that developing in a single tree leads to
better results. Can you provide some example from the QEMU/KVM projects
where the split is preventing innovation, optimizations, or some other
kind of progress?

Let's assume this gets merged. What will change for people working on
generic or x86 KVM features? Will they sooner or later be asked to
provide corresponding bits also for the tools folder? Having worked on
two userlands over the past years (QEMU and qemu-kvm), still
contributing to finally unify them, I'm wondering if this will end up
repeating the painful history.

That said, I definitely appreciate the bug fixes as well as code and
documentation improvements for KVM that originate from this effort! I'm
just not convinced that writing a new userland and merging it into the
kernel is the most efficient way to achieve that.

Jan


--------------enig58CDF04F9EFFC94C8ADF4ED1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4spuEACgkQitSsb3rl5xQlAACgyQfdveUUAIO8BxaopfbkPbGK
p38An1bl0y6pUDCPbj08a6yb0wdbcVV/
=2275
-----END PGP SIGNATURE-----

--------------enig58CDF04F9EFFC94C8ADF4ED1--
