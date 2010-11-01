Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab0KAQh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:37:58 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:33949 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0KAQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:37:55 -0400
Message-ID: <4CCEECE2.8060003@web.de>
Date: Mon, 01 Nov 2010 17:37:54 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, kvm <kvm@vger.kernel.org>,
        Sheng Yang <sheng@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash on kvm_iommu_map_pages
References: <4CCEB7CF.8030207@web.de> <4CCEB946.7070103@web.de> <20101101132127.GF20959@amd.com> <4CCEBFAC.1000809@web.de> <20101101135322.GG20959@amd.com> <4CCECD17.3080303@web.de> <20101101143526.GD2987@8bytes.org> <4CCEDCD7.1000908@web.de>
In-Reply-To: <4CCEDCD7.1000908@web.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBDFCF7F84EEF71670E478356"
X-Provags-ID: V01U2FsdGVkX1/i3rYVqg7tnph9cVV0QlWxwE9O6c7RKhPgsE2T
	iULXcJKt3M7vPqbkdQ0no8rpvo4KS9nHIkvoBZJtC+A5jY4Ii9
	DbkR1Wf8U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBDFCF7F84EEF71670E478356
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.11.2010 16:29, Jan Kiszka wrote:
> Nope. But I just noticed a fatal thinko in my fix to
> intel_iommu_attach_device - probably that was the key. Need to boot the=

> test kernel...

That was indeed the reason for this GPF: I blindly swapped the
problematic lines, releasing the wrong page. Sorry, false alarm this
time, will send out the corrected intel_iommu_attach_device fix later.

Jan


--------------enigBDFCF7F84EEF71670E478356
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkzO7OIACgkQitSsb3rl5xQ0RQCgsxYl31TWPTHysiHCf73OJ4E8
zhUAnjMHesq6erKomKT3xa3CMbz3VKJ3
=WbES
-----END PGP SIGNATURE-----

--------------enigBDFCF7F84EEF71670E478356--
