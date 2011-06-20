Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1FTRGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:06:00 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34337 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab1FTRF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:05:57 -0400
Date: Mon, 20 Jun 2011 20:05:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Skacore Systems <skacore.systems@gmail.com>
Cc: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>,
        Viliam Mateicka <viliam.mateicka@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
Message-ID: <20110620170551.GE26623@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
 <Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
 <20110620151522.GN14262@legolas.emea.dhcp.ti.com>
 <BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
 <20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
 <BANLkTik-zdp57zTjrafR0jXGoJiq2hrm3g@mail.gmail.com>
 <BANLkTi=tuh028X-Rr9i8ZF_B_Q6VBK2-Lw@mail.gmail.com>
 <20110620160650.GA26623@legolas.emea.dhcp.ti.com>
 <BANLkTi=nEma5muF9R3_QUzZWWJ64DW9Skw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
In-Reply-To: <BANLkTi=nEma5muF9R3_QUzZWWJ64DW9Skw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 20, 2011 at 06:41:59PM +0200, Skacore Systems wrote:
> Yeah I think that one line break and tabs are sabotaging your work.
> So stop being an 8=3D=3D=3D=3DO - hole. No wonder if you are paid by TI t=
hat
> one line patch into the upstream takes you so long to comprehend.

you are this close for me to drop your fix and add you to the shitlist.

--=20
balbi

--FN+gV9K+162wdwwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/33vAAoJEAv8Txj19kN149gH/1T/zf8dtRToK0Qd43D6/hWV
nQXGZfh46ZwiuzHwrzNcEbLjL8Cwb2RotMae3srhnfzkP/+3Jdmc77vLIailjU0z
2o5saj4TA1w/WWiknA8caLfK+vj0mVJMAb7wE72sHCTquTAf6eoLR7ZTvNmuMOGW
OS5OtZSFKhmIVXf8Wva0qyVE6A/pc3Yp0WjBIzQSCq5c7XE1+eFr1CdTOpQ39H52
98GmgNCBs/bM8ddp0ByCdDaQ7Kwz233jrOODFZQldP6M8COeXbHImJ2jxPwmWiyE
g9g6KrdIaiEyvOCIj46aV0/2F11qmXA4VIXPvrPApJ5Ogb0qvUI8OFq6satm5GM=
=cWLN
-----END PGP SIGNATURE-----

--FN+gV9K+162wdwwF--
