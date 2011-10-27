Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1J0Pwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:52:45 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42840 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1J0Pwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:52:44 -0400
Date: Fri, 28 Oct 2011 02:52:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unable to fetch the leds and backlight trees
Message-Id: <20111028025232.2fbe463c0dbbb6b02c278515@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Oct_2011_02_52_32_+1100_eRz+QkG.4U9HtSmJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Oct_2011_02_52_32_+1100_eRz+QkG.4U9HtSmJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

Fetching the leds and backlight trees produces this error (after a long
delay):

fatal: read error: Connection reset by peer

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_Oct_2011_02_52_32_+1100_eRz+QkG.4U9HtSmJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOqX5AAAoJEECxmPOUX5FExlQP/24XKZZc/FfFFMlNwuyKvjIf
/BYi2Pi0Wn+2f+mOvVYBv8wEnsd4Ve+zcbRkFbWt2P0/zhXRrYd83S/m1DcIMMsV
khtuXiDxk4NPFM8MWGSiA+O3JIH/6Y4l35l5tm/31zWSd0xXaAYkocKxa5nnkL9P
X7LV3EIBqePrVYhU6+aqLQjocEYt2rNMZOBeMIfGa1WMDyZhpa3KdaEK7T8lNbjK
wyWp5/RS+f0qVbdQaU0WF6eNSUSVn7JE63bnY3tShc/xOZPzJEJ+zO4HXFQAm5uS
pO/e6+Uou7fqalQKRq/n2n5lu22pIqP0QEPyWFKwUI41+mxekZKIP2v0HLA8046+
BZni88WsT5xSe8Fa0t4Wh0+oqdz+AuZYCVxHlLteuhdLCJ5BRgJur0XwuEtrdmwt
rvD0dDo6yC89fvETu9+1FQie3tfIl94cPF6dA7/KQPweFcFJTuHGD901edYaQIdl
9x5tDmH7esZCWywpYbhHKz+og9/ySn2WVi2Ucu4hlwgzTEJZfxcz437hSZImX9Ra
NEfD8Djje7SY0dCQiyXJ7/7RrKmdQvjCL6t6D8Yys+J3cHz9wo3K00XvlkJkID/F
avmcrJ98bLDg6t2HoSo2CmJgb8SUh3VgDc6NTPMsVBHLPmlCtfhOKx3DWf1R6qkL
XTDs2eU1zTcTS8UbD3dN
=nvHE
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Oct_2011_02_52_32_+1100_eRz+QkG.4U9HtSmJ--
