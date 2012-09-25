Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2IYAqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:46:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34445 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2IYAqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:46:15 -0400
Date: Tue, 25 Sep 2012 10:46:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: linux-next: manual merge of the userns tree with the security
 tree
Message-Id: <20120925104605.46288817480e6a6ced31f5fc@canb.auug.org.au>
In-Reply-To: <87txunwi84.fsf@xmission.com>
References: <20120924215222.8933c5557b17239552f0b1d1@canb.auug.org.au>
	<87txunwi84.fsf@xmission.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_10_46_05_+1000_pc3q2fm=h3xCNgwN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_10_46_05_+1000_pc3q2fm=h3xCNgwN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Mon, 24 Sep 2012 08:31:07 -0700 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Right.  To work when user namespace support is enabled fowner needs be
> converted to a kuid_t as well.
>=20
> When I did a trial earlier this is what I wound up with.  As long as
> user namespaces are not enabled what you wound up with should be fine.

I will use your resolution today.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_10_46_05_+1000_pc3q2fm=h3xCNgwN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYP7NAAoJEECxmPOUX5FE0lwP/Rs5F+49G7rWrgqhy7ud5gSz
ABzrI7Ax4V9mXs91pvUbr7PHt9qksIFx1r6LrUys163kYkLb5i2O1vT2cAXsIfRk
mmSJWUFgUMKzAdX3vYmMDOt3tr5BivirLj7wmNhmrKw+kEsVHdrz3okbjIoysZHx
tPJi2oCwYuI16l08KBlSKgyk1QS4gHMTKinrc6xiHxX+hCOSRoy0JBFE4JtpBnRt
RcUHJvhAhmIEJ7Iz2rjA/xaO8L6gm32hXxaPjRABFJcMI1XEySJBCROWCfrj6ebP
mf2SyXv9AV+Y5BB0L4hm0nsnVJi1zpNFlPe2YspYiR67MAJ2xoiNhwOfduKqvQn6
RsvfPHMZb5xX99kzV3D6ZSCUF8OFSTVN8pgD7aahltfbVxTzqBi16WTBojB1XYsz
t6uE4COK21fkds/1E9CnO2vICGvlfbcgwqGhVtDGejx9KORUUuJrV1EXzV6EDNBy
ke3wgclQucrcxqxzLWIKqVESdkhDWBBnVdqJD1Fs6cddU5ffBddqN60ivDGJ1DQy
qLJrBwT8eEQkxO5NiSwMgIWuiebfIybrOU1Focyqj5oYr6WcU6jRhOmcwYJP7Onh
ZuwdXacIPFMwzxLa4L8/AvdZ0QRxfhgQA8o/fcl69KatZIrtM/A5Az65gazLAmwV
dqcnB1U/skNJTHKkb4U5
=C/lu
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_10_46_05_+1000_pc3q2fm=h3xCNgwN--
