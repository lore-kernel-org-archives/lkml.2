Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab1CAXZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:25:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36406 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab1CAXY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:24:59 -0500
Date: Wed, 2 Mar 2011 10:24:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the bkl-config tree with the tty
 tree
Message-Id: <20110302102453.b66ed95f.sfr@canb.auug.org.au>
In-Reply-To: <201103020016.53993.arnd@arndb.de>
References: <20110228174007.b6faf01e.sfr@canb.auug.org.au>
	<201103012324.27725.arnd@arndb.de>
	<20110302101357.7d2a3d81.sfr@canb.auug.org.au>
	<201103020016.53993.arnd@arndb.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Mar_2011_10_24_53_+1100_9CrEUg=wLPc_M=eN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Mar_2011_10_24_53_+1100_9CrEUg=wLPc_M=eN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Wed, 2 Mar 2011 00:16:53 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
>
> > So can I remove the bkl-trivial, bkl-llseek and bkl-vfs trees?
>=20
> Yes.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Mar_2011_10_24_53_+1100_9CrEUg=wLPc_M=eN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbYBFAAoJEDMEi1NhKgbsrv0H/2tA3ophjlfa5ONkwIXfCK4o
LTlLq6mySuZkvWlDQEH0jmvySVSrfwg4myJ6vihYeKPo5cY7AOUsn7hkBIB+xWue
uw//pH2VZWfQ9NwJunN6v3igi2LnJzGZdVcH2od4gSd66y4QNBI3QTLSEdBFNvfn
CyyaNFWweRdq/aFaQ27yh3j/x50tnmRwD5tOwEiJ0u1ZObtbmBIFBWEHGPqz3ZP8
1HRn9Wuav4Go7SsHOhg38ZiaHBkGdh9TR2LFigURVJKkyoOzQ3IajaWvESvst4bw
65rvp+1lTGrKlpuCrGJLr2D6DIl8VdcT3T/tJ34IfIBmr3/tSJUQ5bJ8dQB6zu8=
=pDrS
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Mar_2011_10_24_53_+1100_9CrEUg=wLPc_M=eN--
