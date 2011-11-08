Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1KHRKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:10:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19689 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab1KHRKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:10:40 -0500
Date: Tue, 8 Nov 2011 20:11:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Vincer <Andrew.Vincer@redrat.co.uk>
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
        "jarod@redhat.com" <jarod@redhat.com>,
        "error27@gmail.com" <error27@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rc: Fix input deadlock and transmit error in redrat3
 driver
Message-ID: <20111108171122.GA4682@mwanda>
References: <DA69C24DC634074E9591C2B60BFDBC1C730E13@CP5-3512.fh.redrat.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4vu0d+lqoSa2/ZEk"
Content-Disposition: inline
In-Reply-To: <DA69C24DC634074E9591C2B60BFDBC1C730E13@CP5-3512.fh.redrat.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EB96289.0040,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4vu0d+lqoSa2/ZEk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2011 at 04:43:45PM +0000, Andrew Vincer wrote:
> Fixed submit urb logic so hardware doesn't hang trying to transmit
> signal data
>=20
> Removed unneeded enable/disable detector commands in
> redrat3_transmit_ir (the hardware does this anyway) and converted
> arguments to unsigned as per 5588dc2
>=20

This would be easier to review it you put the changes to enable and
disable into one patch and the changes so that we now measure the
buffer length in bytes instead of ints into a second patch.

regards,
dan carpenter


--4vu0d+lqoSa2/ZEk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuWK6AAoJEOnZkXI/YHqRW/oP/RRbpcB1bqc36u7mlM3VFYv0
5DHxeQC/hV+eSEFqvEbxLK2fcEtmNj0256Ch2Z+utrZdKs1K9DvYsNp7VneYEu5H
CfIZJQrM7O0MGM9USACqIhTEuJINU9BxEszpKSyfnPjlZYaTk2T5gV0ScRv2u8dJ
6Cc/hxwk8/Nc/7AxlyB0+TjyjX8tX1wMhEgMkyfhilCMM5ylMQ2G2QBBgWzysQtp
v7D0r0j9GH46Bvuk+pfG/t0YrNqtrOUivKF2/16iU/8iWzQsSAk6+WwXOJqItvLx
sX0XC8a5ZCwu/qaPilUXo7440Mj/NJJUGL9SxbAMHt5CHuy1g/xwNVA19RrvSVI8
Anv5ltRaSFWiDyWZYbRMKGfUODzj56Fa8CVx7Mvx9Ln09sxPDKSkrWGP2K5VFSp0
EfYKDCWMh9a/OJvZFGbPVyyHQysFEobMurneRkqsNIgVr7WrT5z44tF/JsuBzHw2
4rECNi+aui8f8F4p2TpqqWuEw4WbPMxSYOPu9KkBb3HYGcKCFhlEZ78nUUbOnHcI
qyYPONW7v3YO90slXIL1trhUGKgJ9lXVcScxv081hfPOZmKicsPMYMt5Iy/LsXtS
Uug4oTyvcmGQwi4p7QiFtkjNTXwDLnj6plr+6ci2H3kOLX5Oe0FClN/lGDO3L2pT
41xhyT/ZvjYnmn4aibON
=W0mn
-----END PGP SIGNATURE-----

--4vu0d+lqoSa2/ZEk--
