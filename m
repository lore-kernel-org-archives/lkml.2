Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0IHIzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:55:06 -0400
Received: from mao.cendio.se ([193.12.253.101]:44762 "EHLO mail.cendio.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871Ab0IHIzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:55:03 -0400
Message-ID: <4C874F60.4080901@cendio.se>
Date: Wed, 08 Sep 2010 10:54:56 +0200
From: Aaron Sowry <aaron@cendio.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Help decoding oom-killer output
References: <4C8744D1.1010405@cendio.se>
In-Reply-To: <4C8744D1.1010405@cendio.se>
X-Enigmail-Version: 1.1.2
OpenPGP: id=1F7902FD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig652EE521772169E206FD819D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig652EE521772169E206FD819D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/09/10 10:09, Aaron Sowry wrote:
> Since this change, oom-killer seems to think we are running out of
> memory, and starts killing arbitrary processes. Output from 'free' does=

> not indicate any lack of memory resource:

=2E..however I have just noticed that low memory allocation appears to be=

somewhat stingy, given the total amount of RAM available:

tle-thn18:~ # cat /proc/meminfo
MemTotal:       37115096 kB
MemFree:        34528308 kB
Buffers:           49356 kB
Cached:           861024 kB
SwapCached:            0 kB
Active:          1830136 kB
Inactive:         549420 kB
Active(anon):    1442900 kB
Inactive(anon):    73056 kB
Active(file):     387236 kB
Inactive(file):   476364 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:      36931780 kB
HighFree:       34520552 kB
LowTotal:         183316 kB
LowFree:            7756 kB
SwapTotal:       4200988 kB
SwapFree:        4200988 kB
Dirty:              2624 kB
Writeback:             0 kB
AnonPages:       1469264 kB
Mapped:           203692 kB
Shmem:             46780 kB
Slab:              95460 kB
SReclaimable:      31968 kB
SUnreclaim:        63492 kB
KernelStack:        9952 kB
PageTables:        31660 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    22758536 kB
Committed_AS:    4689664 kB
VmallocTotal:     524288 kB
VmallocUsed:       34520 kB
VmallocChunk:     311868 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8184 kB
DirectMap2M:      491520 kB

--=20
Aaron Sowry
Developer / Technical Sales
Cendio AB
Wallenbergs Gata 4
583 30  LINK=D6PING
Sweden
aaron@cendio.se
Tel + 46 13 29 08 54
Fax + 46 13 21 47 00


--------------enig652EE521772169E206FD819D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMh09lAAoJECw8YUUfeQL9YcEH/jjKIistMBAamLDO/dZbtOd7
b8jAHlT5NLH00merr8BplmHhgEsHhDZTE/SrpRgy9+LqaSak8cqVCxx6jVDIo4W+
uy+zMz+nBYNj+uqimI21To78ywsdX6ITDENDxKcY21sLnBKD6yga4Durkz8hrJuj
spjD5gxi2NEA/4xsAQAG6orGV1yQa9xUYxH90dfHjdzphxwuiVIR01uKEGe9MUsK
3NHjP/ng/0jMyjz6OAECH9UfmLo0PsIumcgWBAyVn/F1ps97lKlTsh9xtGqXDFmw
crHIweaXlca/HoL86mY0Vr1cw2VYky/fhNWFWIGOuIzei0PXugx8q6cxLwqDOwE=
=LokX
-----END PGP SIGNATURE-----

--------------enig652EE521772169E206FD819D--
