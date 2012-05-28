Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2E1Mvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:51:31 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:56472 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2E1Mva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:51:30 -0400
Message-ID: <4FC374CD.5000509@web.de>
Date: Mon, 28 May 2012 14:51:25 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: Mark INTx masking support of Chelsio T310 10GbE
 NIC as broken
References: <4FBF90E5.8030800@siemens.com> <20120528123934.GB21778@redhat.com>
In-Reply-To: <20120528123934.GB21778@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigED19D68126CB788B6D6DCC8D"
X-Provags-ID: V02:K0:ND3PxNj+pNgHixJZGoFdz2kgogrxth1GIPe+hYfZAnH
 dN0nI4nRN84Pdhj1x3ogul9szvM6lYCneJrhgJVIT7o/6vuX7L
 S9lv3VdkvLvc0jFXoRJtqAVsq+eS61YdMHX2lONUJhD8eaL/zE
 9B6EF/at3BJYcrTTAbacuAZ/J1/o3z4U7uPZuy/AsMrYNWwBYA
 vELO4a0Xvu2K9JBg+wOxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigED19D68126CB788B6D6DCC8D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-05-28 14:39, Michael S. Tsirkin wrote:
> On Fri, May 25, 2012 at 11:02:13AM -0300, Jan Kiszka wrote:
>> According to Alexey, the T310 does not properly support INTx masking a=
s
>> it fails to keep the PCI_STATUS_INTERRUPT bit updated once the interru=
pt
>> is masked. Mark this adapter as broken so that pci_intx_mask_supported=

>> won't report it as compatible.
>>
>> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>=20
>=20
> Just a thought: would be nice to have a way to discover
> the quirk was activated. Add an attribute so that
> userspace can detect and report this properly to users?
> Or just log a warning message ...

pr_notice_once? A flag for userspace would be significantly more
complicated (and not PCI layer hands).

Jan


--------------enigED19D68126CB788B6D6DCC8D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/DdM0ACgkQitSsb3rl5xRhbwCgh5FZWOvNUt5XLB3RyBEMvllL
1acAoMxa06Z7VT1a1/uTz4xFnPZtoo+s
=Q9pw
-----END PGP SIGNATURE-----

--------------enigED19D68126CB788B6D6DCC8D--
