Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab1JRNxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:53:25 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:33050 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753502Ab1JRNxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:53:24 -0400
Date: Tue, 18 Oct 2011 09:53:22 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111018135322.GA11530@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
 <20111010233842.GC24583@mgebm.net>
 <1318319095.14400.54.camel@laptop>
 <20111012165154.GB6158@mgebm.net>
 <CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Oct 2011, Stephane Eranian wrote:

> Could be:
>    a8d757e perf events: Fix slow and broken cgroup context switch code
>=20

Thanks for the pointer, but the fix was in:
    facc4307 perf: Optimize event scheduling locking

This might be a candidate for stable given that oprofile is broken without =
it.

Eric

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOnYTSAAoJEKhG9nGc1bpJ6RsP/0ZykIlSgwrsjVElTFPgoV0J
SFkIarrDfj6K3tiFKwVgbV9zACfCy9r8F1XKJfezKZDIkTFPwodaX8dKtSQ6v3gS
hs1blGXX9IjE0SxgNS1LrmRU+5kWbWMwc2B5m9/ldOMYz8Ay6DSb9IMIjo3eHFxf
sR7ojWElOitBSb6Vonsn9d+LlxjpGM0rijlW5XsPwRxpPnWJB4LoQhNH2kdd45h2
6SOJtF/MFP1ng6MrqBLhZui7sxZ6Nhxbwq+BMEVSUMY7ki4IOcrkPOyAF1TI5qIU
z/5gP1tmoKKCHEEbL0ht1IZHT/bF9m/EaVgUVfZa6kWBk0UKJ2D47ZOkfMEkN4a6
HBEcJnsr/u0ovI7SZJLOFlddye4hw/uT8gkWjuTaHRXZmZspgaxVcbgl2fWlW3B5
7jOYxH4mAxwsOjMmhO8BJSSuqg4Y3RpTQic5Bz74yK57s5SuIdewVjWFIQ2oaouh
WffAh9BUBBMPzU8gJ4UoN0+TaesQeqwyBoda2CwBtNdz6aKB27+1EJIjysTPo+IK
uk0xsBHVRSNcgGEpmt7q/8xhQcalYjoa8LLPwQeTGuaxPeTv4TaoI3YwBLdhd4X0
0SoFHdeBDCrt5pTSs4BeDZ88IKZUgjCN/N2+PR9viUN9mBWQCAf9R8WYsYOSgOL/
qAkJrNlYWTmwBV8+7mi2
=Fpnf
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
