Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab1JGIj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:39:26 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:59552 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759515Ab1JGIjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:39:24 -0400
Date: Fri, 7 Oct 2011 11:39:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111007083918.GC10910@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <1317975394-5781-1-git-send-email-schwarzkopf@sensortherm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <1317975394-5781-1-git-send-email-schwarzkopf@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 07, 2011 at 10:16:34AM +0200, Klaus Schwarzkopf wrote:
> This driver provides two functions in one configuration:
> a mass storage, and a CDC ACM (serial port) link.
> Heavily based on multi.c and cdc2.c
>=20
> fixed missing header in include/linux/usb/gadget.h

why is it missing ?

--=20
balbi

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjrq2AAoJEAv8Txj19kN1loAIAIPRYoIK++5TN9JKNLTQRBwP
vH+aUvjo3blzJRSQjkjxvnotSSH2gyUiPX5HP2ghl1e62fy5+EXFRTR1iHstxuQi
YN7I/yxcr6jjdKSDoWBtvt9uy5n1g++0pOlE3XPB/EwnMd+4n5M9fzmmKKPVMQ1m
IB6H65htaXHRK2KotroiWtWwjLGNDiD/4UgS6446GJ+BYLBYqh38LPKjIMBfxRks
sT601E2UIYnX0MvnLW1ydZJ6ta06fyPa8a+fY5DbZPdLYWoy+FqWTNcb6TKFXqAj
3MRoRUyteBkozC++lNtjkw9UNPAdM6j+ixIEBihXKN4rVYlFoKZia9rnVI1Br04=
=0S3F
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
