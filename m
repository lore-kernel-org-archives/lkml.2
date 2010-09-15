Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab0IOIEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:04:16 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:35214 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0IOIEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:04:10 -0400
Message-ID: <4C907DF4.8000601@web.de>
Date: Wed, 15 Sep 2010 10:04:04 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C8F3FF3.9080803@redhat.com> <4C8F5125.5060505@siemens.com> <4C8FCDE2.3000202@redhat.com> <4C8FF690.7030107@web.de> <4C9007F2.9020205@redhat.com> <4C905AFC.5020706@web.de> <4C907C0A.7060607@redhat.com>
In-Reply-To: <4C907C0A.7060607@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDC4C91EF72B82E2AC9020A91"
X-Provags-ID: V01U2FsdGVkX1/ZJa5WVwjyw6ZKCQuHSUAFjuiZvMBkV7mFK1ga
	uMvm+bjbT/Jbp9TboLltE3yslET/ENlPS0M5U8l5+ncvkk2GtG
	5mPxgZRVc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDC4C91EF72B82E2AC9020A91
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 15.09.2010 09:55, Avi Kivity wrote:
>  On 09/15/2010 07:34 AM, Jan Kiszka wrote:
>> Do you think kvm-kmod could contribute to this? As I said, I'm on a 34=

>> kernel, namely SUSE's 2.6.34.4-0.1-desktop. Any feature missing in tha=
t
>> kernel latest KVM depends for proper tsc/kvm-clock handling? If you ha=
ve
>> any concerns, I could try to run kvm.git natively later on.
>=20
> In case you aren't aware of it, 'make localmodconfig' is an easy way to=

> transition from a distro kernel to a locally built kernel.
>=20

I am aware of it. But this doesn't remove the need to shut down my
session and reboot the notebook - something I usually avoid for weeks or
even longer.

Jan


--------------enigDC4C91EF72B82E2AC9020A91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkyQffkACgkQitSsb3rl5xRjrwCcDwKJ9Dxi9m1kodk5CMyLlVJg
iVUAoK+4Dy8poW2PGTDiXhMToBITKpZb
=nWkn
-----END PGP SIGNATURE-----

--------------enigDC4C91EF72B82E2AC9020A91--
