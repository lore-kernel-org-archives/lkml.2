Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1KWPKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:10:14 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:41636 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab1KWPKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:10:13 -0500
Date: Wed, 23 Nov 2011 16:09:50 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Subject: MCE/Package power limit notification
Message-ID: <20111123160950.67860131@x220>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tvOSRwUVBmlo7oFRV6kuxmK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tvOSRwUVBmlo7oFRV6kuxmK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

After half an hour of compiling code on an Intel SNB machine, at which time
the machine was more or less permanently running with turbo boost active,
I've gotten the following in my dmesg with Linux-3.1.0:

CPU2: Package power limit notification (total events =3D 1)
CPU3: Package power limit notification (total events =3D 1)
CPU1: Package power limit notification (total events =3D 1)
CPU0: Package power limit notification (total events =3D 1)
CPU2: Package power limit normal
CPU3: Package power limit normal
CPU1: Package power limit normal
CPU0: Package power limit normal
[Hardware Error]: Machine check events logged
CPU1: Package power limit notification (total events =3D 655)
CPU2: Package power limit notification (total events =3D 655)
CPU3: Package power limit notification (total events =3D 655)
CPU0: Package power limit notification (total events =3D 655)
CPU3: Package power limit normal
CPU2: Package power limit normal
CPU1: Package power limit normal
CPU0: Package power limit normal
[Hardware Error]: Machine check events logged

Below is the output from mcelog. Is there anything that can be done about i=
t?

Cheers,

	- Udo

mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 0
CPU 3 THERMAL EVENT TSC 179fecf42d7=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 3 below trip temperature. Throttling disabled
STATUS c0000000880c0c00 MCGSTATUS 0
MCGCAP c07 APICID 3 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 1
CPU 1 THERMAL EVENT TSC 179fecf5d95=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 1 below trip temperature. Throttling disabled
STATUS c0000000880c0c00 MCGSTATUS 0
MCGCAP c07 APICID 1 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 2
CPU 0 THERMAL EVENT TSC 179fecf72fb=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 0 below trip temperature. Throttling disabled
STATUS c0000000880c0c00 MCGSTATUS 0
MCGCAP c07 APICID 0 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 3
CPU 2 THERMAL EVENT TSC 179fecf88a9=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 2 below trip temperature. Throttling disabled
STATUS c0000000880c0c00 MCGSTATUS 0
MCGCAP c07 APICID 2 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 4
CPU 3 THERMAL EVENT TSC 179fef2e964=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 3 below trip temperature. Throttling disabled
STATUS c0000000880c0800 MCGSTATUS 0
MCGCAP c07 APICID 3 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 5
CPU 1 THERMAL EVENT TSC 179fef2fd56=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 1 below trip temperature. Throttling disabled
STATUS c0000000880c0800 MCGSTATUS 0
MCGCAP c07 APICID 1 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 6
CPU 0 THERMAL EVENT TSC 179fef30d22=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 0 below trip temperature. Throttling disabled
STATUS c0000000880c0800 MCGSTATUS 0
MCGCAP c07 APICID 0 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 7
CPU 2 THERMAL EVENT TSC 179fef311bd=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 2 below trip temperature. Throttling disabled
STATUS c0000000880c0800 MCGSTATUS 0
MCGCAP c07 APICID 2 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 8
CPU 2 THERMAL EVENT TSC 31a70403488=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 2 below trip temperature. Throttling disabled
STATUS c000000088080c02 MCGSTATUS 0
MCGCAP c07 APICID 2 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 9
CPU 3 THERMAL EVENT TSC 31a7040468b=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 3 below trip temperature. Throttling disabled
STATUS c000000088080c02 MCGSTATUS 0
MCGCAP c07 APICID 3 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 10
CPU 0 THERMAL EVENT TSC 31a704059b1=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 0 below trip temperature. Throttling disabled
STATUS c000000088080c02 MCGSTATUS 0
MCGCAP c07 APICID 0 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 11
CPU 1 THERMAL EVENT TSC 31a70407082=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 1 below trip temperature. Throttling disabled
STATUS c000000088080c02 MCGSTATUS 0
MCGCAP c07 APICID 1 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 12
CPU 2 THERMAL EVENT TSC 31a705416f8=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 2 below trip temperature. Throttling disabled
STATUS c000000088080802 MCGSTATUS 0
MCGCAP c07 APICID 2 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 13
CPU 1 THERMAL EVENT TSC 31a70542907=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 1 below trip temperature. Throttling disabled
STATUS c000000088080802 MCGSTATUS 0
MCGCAP c07 APICID 1 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 14
CPU 0 THERMAL EVENT TSC 31a70543945=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 0 below trip temperature. Throttling disabled
STATUS c000000088080802 MCGSTATUS 0
MCGCAP c07 APICID 0 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42
mcelog: Unsupported new Family 6 Model 2a CPU: only decoding architectural =
errors
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
MCE 15
CPU 3 THERMAL EVENT TSC 31a70543cab=20
TIME 1322060688 Wed Nov 23 16:04:48 2011
Processor 3 below trip temperature. Throttling disabled
STATUS c000000088080802 MCGSTATUS 0
MCGCAP c07 APICID 3 SOCKETID 0=20
CPUID Vendor Intel Family 6 Model 42

--Sig_/tvOSRwUVBmlo7oFRV6kuxmK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7NDL8ACgkQnhRzXSM7nSl3FgCfS8whdb0m6gB47AP70Si+MJ84
muIAoIEyXFbewgViqV4w9eMK8PSlU5w9
=sr0a
-----END PGP SIGNATURE-----

--Sig_/tvOSRwUVBmlo7oFRV6kuxmK--
