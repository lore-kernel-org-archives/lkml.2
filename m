Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2IMM6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:58:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43031 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab2IMM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:58:00 -0400
Message-ID: <5051D84F.4080605@pengutronix.de>
Date: Thu, 13 Sep 2012 14:57:51 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd/janz-cmodio: fix MODULBus number sysfs entry
References: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu> <1347404295-7985-2-git-send-email-iws@ovro.caltech.edu> <5051C9F0.3050600@pengutronix.de> <20120913125201.GB3647@sortiz-mobl>
In-Reply-To: <20120913125201.GB3647@sortiz-mobl>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD8C039140DB92FDA42B88E47"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD8C039140DB92FDA42B88E47
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/13/2012 02:52 PM, Samuel Ortiz wrote:
> On Thu, Sep 13, 2012 at 01:56:32PM +0200, Marc Kleine-Budde wrote:
>> On 09/12/2012 12:58 AM, Ira W. Snyder wrote:
>>> From: "Ira W. Snyder" <iws@ovro.caltech.edu>
>>>
>>> Revision 1.0 of the Janz CMOD-IO Carrier Board does not contain zeroe=
s
>>> in the top 4 bits of the modulbus_num (int_enable) register. Mask off=

>>> the unused bits so that the correct value is displayed in sysfs.
>>>
>>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>>> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
>>
>> Who will take care of this patch?
> I will.

Tnx.
 I'm taking the other one.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigD8C039140DB92FDA42B88E47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBR2FIACgkQjTAFq1RaXHMKFwCfUqZmZB6f7aHpVfTLcVzNBLtF
IwsAn3dY/aorQPNPJB+Al0FZZzCu5nQO
=n+XS
-----END PGP SIGNATURE-----

--------------enigD8C039140DB92FDA42B88E47--
