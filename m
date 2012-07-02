Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab2GBLjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:39:48 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:33601 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749Ab2GBLjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:39:46 -0400
Date: Mon, 2 Jul 2012 14:37:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Felipe Balbi <balbi@ti.com>,
        ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/17] Big OMAP I2C Cleanup
Message-ID: <20120702113712.GB2730@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339691067-919-1-git-send-email-balbi@ti.com>
 <20120614175950.GE14419@pengutronix.de>
 <4FE99432.8030300@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <4FE99432.8030300@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 26, 2012 at 04:21:30PM +0530, Shubhrajyoti wrote:
> On Thursday 14 June 2012 11:29 PM, Wolfram Sang wrote:
> >> 	- removed dev_err() which was introduced on patch 09/17
> > To prevent the list being flooded, I would appreciate if you could wait
> > a few days to collect reviews before resending. It will take some time
> > until I pick this series anyhow, because I want people to have time to
> > donate Tested-by tags.
> Felipe thats a good cleanup.
> The series look good to me.
>=20
> Also draining interrupt I had some queries.
> Looks good to me.
>=20
> I have tested it after rebasing.

rebasing on top of what ? You should resend the series so that I know
what changes you have made to my original patchset. Make sure to list on
the commit log what where the changes you made, so that it looks
something like this commit below where I changed commit log a bit:

| commit 3daf74d78dfcd552445c35f1b82a271ca305ceb9
| Author: Pratyush Anand <pratyush.anand@st.com>
| Date:   Sat Jun 23 02:23:08 2012 +0530
|=20
| usb: dwc3: remove WARN_ON from dwc_stop_active_transfer
|=20
| Now we are sure that, if res_trans_idx is zero, then endpoint has been
| stopped. So it's safe to just return if endpoint is already stopped. No
| need to generate warning anymore.
|=20
| While doing so, it's better to return when res_trans_idx is zero and
| decrease one level of indentation.
|=20
| Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
|=20
| [ balbi@ti.com: slightly changed commit log ]
|=20
| Signed-off-by: Felipe Balbi <balbi@ti.com>

> Tested-by : Shubhrajyoti <shubhrajyoti@ti.com>

since you will send, you should, probably, add your Signed-off-by,
instead of Tested-by. dunno.

--=20
balbi

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8YfoAAoJEIaOsuA1yqREUHQQAKOHfeyMa68loT6jvnm6Dbdw
e3m/ai6bwnWhFCrImeFY370PuuuC9EX0YuppJHA8OKIfMhEjXoFlNK/AE3I9ROaU
RVSpu7AVcaWzX3dkLE+KWNlHis/B3X/rdU9no8WhSeeBEqCWVl85s6iP28zZvmby
ATJ00tmO8pCK8IMiEBa8I+BeYYeceGgKnpU1qd68WGmoyrgl7zcclpCpGdhBvfZE
QgcpKGEFLGK51AqkIExDQExZkVXzk3JFN3yem3zcTqMB9exMnwdi1rrdEUb2ddYw
mBfapfAvRSBHpJyKAiBq6NEaEPA588Y1U+A2mHIMLlWA/vDolMebtE5hjnI1TOLZ
b+1HseBTlOAmW6rlw8S061lEcBhYWLzPiS0C1XUDf4ztKyLGzqcAVteQs6DrZjBJ
y8CA5TxrCwHwCMW2jjWDfwm9OxCFX7JSurCZt7006V+aikmVhRq678aOsaRPBR1I
+bFeTM6imnzg166feXzSIg1Whhfm7b5EWIcXlP9KrIRw/VtHIPd1hF8DnosJhEvq
m/MDw8IoGhGdaUPW0mRcPmcbouyeYVG4ar5DPz9a9BLOWuuRr2T7mwEMRWo4rBNh
PGRAYn7oFFuDWXtUIsJrx6lmEWkZS8BU5PHYSOxV12nayEdvxKmDQYklTsWhlQci
Q7G+FjVKnEliZLixlQKy
=3PxV
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
