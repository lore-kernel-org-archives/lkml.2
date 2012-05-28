Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2E1NaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:30:06 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:36762 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2E1NaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:30:04 -0400
Message-ID: <4FC37DD6.7090000@web.de>
Date: Mon, 28 May 2012 15:29:58 +0200
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
References: <4FBF90E5.8030800@siemens.com> <20120528123934.GB21778@redhat.com> <4FC374CD.5000509@web.de> <20120528132109.GB22623@redhat.com>
In-Reply-To: <20120528132109.GB22623@redhat.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB9AA42A9FC14B52246BE44AE"
X-Provags-ID: V02:K0:WHWvN7trlxhwMvIJ3P8mnVKlpgXaIvA7okSzC+/TIqj
 8bwD4AnKDdUu5sBEdpc+hT4cTZSTyutqtomRtZtkskXi+fxVIb
 glfW36BYVEIarsKBRAQIhLt2E6tmX3fl9goo9xhDiV0sqoHz4q
 VodSlDnsAcpvJYyPYY52CNsNKvxRp1djUiow/E3xTJcLL8unmF
 /pvdV5WymyakihqsgcD8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB9AA42A9FC14B52246BE44AE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-05-28 15:21, Michael S. Tsirkin wrote:
> On Mon, May 28, 2012 at 02:51:25PM +0200, Jan Kiszka wrote:
>> On 2012-05-28 14:39, Michael S. Tsirkin wrote:
>>> On Fri, May 25, 2012 at 11:02:13AM -0300, Jan Kiszka wrote:
>>>> According to Alexey, the T310 does not properly support INTx masking=
 as
>>>> it fails to keep the PCI_STATUS_INTERRUPT bit updated once the inter=
rupt
>>>> is masked. Mark this adapter as broken so that pci_intx_mask_support=
ed
>>>> won't report it as compatible.
>>>>
>>>> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>>>
>>>
>>> Just a thought: would be nice to have a way to discover
>>> the quirk was activated. Add an attribute so that
>>> userspace can detect and report this properly to users?
>>> Or just log a warning message ...
>>
>> pr_notice_once?
>=20
> OK IMO.
>=20
>> A flag for userspace would be significantly more
>> complicated (and not PCI layer hands).
>=20
> Why not? I meant e.g. an attribute in pci-sysfs.

Possible. But what is the preferred way of doing this? Are there any
precedences?

Jan


--------------enigB9AA42A9FC14B52246BE44AE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/DfdYACgkQitSsb3rl5xSVfACfebwPII9PPy5fmXRH0rBr4fWI
djIAoLIFcpLgdi3EJZZ23uTqdr5XvyjA
=5cfg
-----END PGP SIGNATURE-----

--------------enigB9AA42A9FC14B52246BE44AE--
