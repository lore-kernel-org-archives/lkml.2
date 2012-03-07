Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2CGCkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:40:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab2CGCkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:40:40 -0500
Message-ID: <4F56CA9E.2040907@redhat.com>
Date: Tue, 06 Mar 2012 19:40:30 -0700
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v2] deal with guest paniced event
References: <4F56BEF2.4020405@cn.fujitsu.com> <4F56C0E1.1090703@cn.fujitsu.com>
In-Reply-To: <4F56C0E1.1090703@cn.fujitsu.com>
X-Enigmail-Version: 1.3.5
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig30221AB83DEF9DAA0D893769"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig30221AB83DEF9DAA0D893769
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/06/2012 06:58 PM, Wen Congyang wrote:
> When the host knows the guest is paniced, it will set
> exit_reason to KVM_EXIT_GUEST_PANICED. So if qemu receive
> this exit_reason, we can send a event to tell management
> application that the guest is paniced and set the guest
> status to RUN_STATE_PANICED.

s/PANICED/PANICKED/ throughout your series, for the correct spelling of
the past tense of panic.

--=20
Eric Blake   eblake@redhat.com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


--------------enig30221AB83DEF9DAA0D893769
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJPVsqeAAoJEKeha0olJ0Nqo7wH/1MofnbA4R3DpjlU4ayi4K+W
SwwJ/m1N0rRjX8/syuwOy1smMDl1IB1g89UBnRKgCIQUpcKnHv4kMNoB5cr02Q2u
iVlnqIT0/H4pSDBbjJBrtdi3Iztjd4DH5t3cW1tZZBkpl6rWqILrI0V1x/fv66Z7
muXTkDmZ4caX/GkZk4mCm4+FwY1CePu82/KWEF92vx8mHOlOwmwj7NLJMlO3zHxz
QnpEWc90U3LcIdtvxFfNUTtQ7wYstphQsOQIj1b72kU4Z7JatsbHZ9TrC/9Jtj8r
YusJDW2hUbz9m6fMTJqp1qJTAuZXSv9nAdyb4l4T1HExMoVqkjXl4wASealfmTQ=
=iWzV
-----END PGP SIGNATURE-----

--------------enig30221AB83DEF9DAA0D893769--
