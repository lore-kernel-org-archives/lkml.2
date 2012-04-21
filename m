Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab2DUPkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 11:40:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39537 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab2DUPkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 11:40:52 -0400
Message-ID: <1335022841.3209.324.camel@deadeye>
Subject: [PATCH linux-firmware] Remove unused 'mwl8335_duplex.fw'
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, Dan Williams <dcbw@redhat.com>
Date: Sat, 21 Apr 2012 16:40:41 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/Hkz/5kKTbwWiKUUJWhQ"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/Hkz/5kKTbwWiKUUJWhQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've just pushed the following change to linux-firmware.git

Ben.
---
This blob comes from the out-of-tree mwl8335 driver.  It was intended
that the driver would be cleaned up and added to mainline Linux, and
would use this external firmware file.  Unfortunately that has not
been done and the file is redundant.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mwl8335_duplex.fw |  Bin 51596 -> 0 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 mwl8335_duplex.fw

diff --git a/mwl8335_duplex.fw b/mwl8335_duplex.fw
deleted file mode 100644
index 9490d053a65bfb434bcff78939957e16924540da..000000000000000000000000000=
0000000000000
--=20
1.7.10



--=-/Hkz/5kKTbwWiKUUJWhQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT5LU+ee/yOyVhhEJAQqZRg/+MqoTfv25y5QIr1bCcQ/Wus5wAmu0lwSG
Vf1mdEpoFyAsklShAX35EOwzDdnCy1gYPCkQqBkGrQbKzMx+F0TLCt87Hkvowfuq
q8dezCawid43YjEINIgnWH9rBLkbWlYsFSyR2iSRY3W8FUcOe94VDsXm4WOZymrl
xYaC6ZdnPTbFnGslCLUVuhueSDunCi4k9usVwKL7+p1oq2wPMiktq9MuS1tY9myX
+HGvBcImsqeTpSeegQ8k98tUq1n0eO11L0EdwfUP9nTRKe8G0Yqocbaq/A076D9N
u0ABaiVHM3RNtHeSyUXTP0+9xIS3XKfCEyEIp4Jp5hjcCV1fPhCKPzlRpdsf10xZ
K10EQTezcxN0o6fzG8fcAzatANZXkn93Q1JRdnaM4msGYCLu1RvoHVzaUdUYwCuo
w/aknh99+bPKXhWwwlkYps4H+aPvHrp5uVkHIJGo3N2Si4WcYKjuGJBJpt9wHc10
rApaORGSRbcIIgqWtDnWX/YssxulS/r39VSafAZJKr1jhJM1ljvySSuCa9r20sx+
jhE+lP6NMNy+63DO25e8B3NVGoWcsD5w1APev69yDTA67cI2TaNQsDazAskIGEq0
MZlIsZpUl7wvGFjGxXGCIDc7ChL556mmzV0e5GJ2fdotU5Oqkwmy9k9upsppa6wj
jsHbDhvTn20=
=SW+V
-----END PGP SIGNATURE-----

--=-/Hkz/5kKTbwWiKUUJWhQ--
