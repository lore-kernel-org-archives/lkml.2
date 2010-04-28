Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0D1H7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:59:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59508 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0D1H7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qS0N8ubum31873bcwX9P+zLQM6QT7qFQR2w+k1BpvmvRwWBx4SYzb2YXOguvgk5+ZO
         CKrdpiXWAbRYfVDGKcRBKzoBBFh4J61M4rKYepHGuLLpQJbA7GucCPh2aVx3Kjt7Y0dz
         XVZq3s0Mqjs+O02kCWw9thbhX1cnXjJKisWxI=
Date: Wed, 28 Apr 2010 11:00:27 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: INFO: umount blocked for more than 120 seconds
Message-ID: <20100428080027.GB30496@swordfish.minsk.epam.com>
References: <20100427094614.GA3345@swordfish.minsk.epam.com>
 <Pine.LNX.4.44L0.1004271457160.1850-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004271457160.1850-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (04/27/10 15:07), Alan Stern wrote:
> Robert was right.  Your usbmon log covers only the last 40 seconds of
> data transfer and showed a little over 15 MB being sent, so it seems
> likely that the entire 246 MB transfer would require more than 10
> minutes.
>=20

Thanks.

> You can test this easily enough by simply waiting for 12 minutes or so
> before issuing the "umount" command.
>=20
So, bug entry is invalid. Right?

=09
	Sergey

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvX6xsACgkQfKHnntdSXjTpPgP/YSOu9u/z1HNRNwbxNMNTziRX
Y9PW1WeBEehSdCnvk4+m02fHxcK7aWdUN92UwP6p9rdrtzrPdtj8vK1rUpPKkwVU
SpI1Yu959S1ZCW9JP1A5U/P4S4c4masNgcjp9z0DRo9xPBj8Oc4BV0LdnYAxznQ+
8T5ZHVQgC6urEK+Ic7s=
=XMY/
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
