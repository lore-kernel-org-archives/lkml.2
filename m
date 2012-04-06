Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2DFGko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:40:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39805 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2DFGkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:40:43 -0400
Date: Fri, 6 Apr 2012 16:40:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: linux-next: sh tree (Was:Re: [PATCH 07/11] sh: fix several build
 failures from system.h fallout)
Message-Id: <20120406164032.8fa7ddee4857f6e9cccdcf33@canb.auug.org.au>
In-Reply-To: <20120405151558.GD23761@linux-sh.org>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
	<1333312727-11428-8-git-send-email-paul.gortmaker@windriver.com>
	<20120402010048.GA21647@linux-sh.org>
	<4F79ECD9.6000108@windriver.com>
	<20120403095754.a70f38eb70766580843debc7@canb.auug.org.au>
	<CAP=VYLpxEvcQv=AOZCU46PQrVn04MC7_Jhodba9z-mmj9XamSw@mail.gmail.com>
	<20120405151558.GD23761@linux-sh.org>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Apr_2012_16_40_32_+1000_7LY.cBw_/vlvzu4d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Apr_2012_16_40_32_+1000_7LY.cBw_/vlvzu4d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Fri, 6 Apr 2012 00:15:59 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
>
> On Wed, Apr 04, 2012 at 10:49:30PM -0400, Paul Gortmaker wrote:
> >=20
> > Is this the tree Stephen should be using in linux-next?
> >=20
> >         git://github.com/pmundt/linux-sh.git sh-latest
>=20
> Yes, that's the current one for sh stuff for now. The rmobile stuff is
> going through the ARM SoC tree nowadays, so that shouldn't matter.  I
> haven't bothered getting the trees back on kernel.org yet, so I haven't
> updated the MAINTAINERS entry, but will probably do so in the future.

OK, I have added that back - using the sh-latest branch for the sh tree
and the sh-fixes-for-linus branch for sh-current (maybe the sh/urgent
branch would be better?).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Apr_2012_16_40_32_+1000_7LY.cBw_/vlvzu4d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPfo/gAAoJEECxmPOUX5FE8SMP/2OTWBP5r55BJFYcq3JjlJHG
+4sD5TVuO+3sgzzuCwi1tPlCYc8HocAGbuAqkPuzbM8XJfcEVHIk9y4zftpwDFOj
+tNqoxUVgQ145Rl1bhTPUX5ZqLEPH7QmTxYIljc9Jcs7FD0O9bse290/br6vqgip
PXGu+8ckiBTuJjYvyj9Q4v94r5jzfqceLLNgzWlLE1hJmdvQ+JtReH1RjvXTz6YG
mGeFI/ZA9nFMAowsv2nPvLgKlWGFdAmnMiXU5N/3U6OmK2eX/WD0PTzF9yU3G2TF
JFTPrBukzZrp//xjDWR+ax/ReZhyCdm84Gue9TbP87yhPmTFAtLemHz/ItOwSWRt
jTzL087joByaOpq04rct0fRxUvIiBZIGGgHAtwW7NNUGeug3xOzHF7WDWx8ecws0
XyKUt5YOLpND20hYEHXH0aW4MnZURTeMPyqZdabL7f++aNtAVIQoBi4Jho4O2VzE
q/NCRRIkqpYxPOQSO2mwf0cEUB8xBtZsxHORyZKXscfwMJZ5gmMLqdf1E+B/rDan
IaiIgtIK2lhjLefABavE5+yydJl2gJ5e928+aTFmAKlFszA4bdswO7fF/i2HY9PV
HPo1ejplFPDV5BTGY8qfU7/NCxvW9+jOHqcaTRsJZfr1Mfrt9M+cY57NFXNsM/Wd
sXZlzI6/c+E1V7tt6Pq9
=T5Xt
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Apr_2012_16_40_32_+1000_7LY.cBw_/vlvzu4d--
