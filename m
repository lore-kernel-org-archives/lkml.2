Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1KHB6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:58:31 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55172 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1KHB63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:58:29 -0500
Date: Tue, 8 Nov 2011 12:58:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: linux-next: manual merge of the bluetooth tree with Linus tree
Message-Id: <20111108125822.2dbe82c96523fc42b42e5893@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Nov_2011_12_58_22_+1100_wZgY6PQEH476JA4_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Nov_2011_12_58_22_+1100_wZgY6PQEH476JA4_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
net/bluetooth/mgmt.c between commit dafbde395ed5 ("Bluetooth: Set
HCI_MGMT flag only in read_controller_info") from Linus' tree and commit
e395042c2836 ("Bluetooth: Convert power off mechanism to use
delayed_work") from the bluetooth tree.

I fixed it up and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Nov_2011_12_58_22_+1100_wZgY6PQEH476JA4_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuIy+AAoJEECxmPOUX5FE52QQAIQ6iHhkiPZFLtkbH1uRKKzk
e1Kcw6vEpNWtt3lHYzXcO1Pa1+mgDO6YPRzEXZDY25lCEqvIbCS5wtHJXNG2zU1f
ADwqKHvGfSr8mEr7tOdw2NczxkitLGug4eWIFSdUcd3hRqFR2+mQeePIQu3JLVJH
w6O9CTe3843CurK7okSHgPoAY8XvkiEQ9fcMflkkrJUYWp7P+T3GHCe3IKxXVYuW
r/+ZZsgOD7TSZVo2dbyMI29TYKY6JZv4EckfbB/y5N9hgxvQOc0jZ0KYTC6ITOZF
UUrjS4KUoPb+3YL0/cCmQMl26OxjWJFEetV1xu+EW/QGpI0IbsDHWgO81HnJLGsT
aiWjebNBmQ5MUsfqIygVvFwzy2YAB1ETSHGcEJ+tf1TLkmfiVyhducdoaxF3izcL
c+XFYzjbx9SQIBcNEZ5W0NtQTdbfmWlTnaTLx7mEQV5TlP9aD/NoUyVTnjIhCKGA
pn0s6bq4/Oya8CESRVt0kXf/moBumYDQURpCWxLthJ0XVg3LOTRqvyi7f7F11iL2
ktpkuMR1XC+9o2paPnxdCVrYFujv9Pg2LriHt7YeuGrkRdkigBW8A/RK/ERZiTkB
aBMIj57oSjRZE9wGX3MyeRE+zkUQ3mNWvhoaqJntTK/NblHgR3b561kQfUUj+TXW
e5s6hR8u94Jh517itOwI
=4zL4
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Nov_2011_12_58_22_+1100_wZgY6PQEH476JA4_--
