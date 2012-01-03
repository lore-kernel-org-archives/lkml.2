Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab2ACHJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:09:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35966 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2ACHJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:09:05 -0500
Date: Tue, 3 Jan 2012 18:08:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the s5p tree
Message-Id: <20120103180854.e9bff732db50c0fa9afd2967@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_18_08_54_+1100_dBBZIUY0H9Ll6HtI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_18_08_54_+1100_dBBZIUY0H9Ll6HtI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

After merging the s5p tree, today's linux-next build (powerpc
ppc64_defconfig) failed badly.   The problem is that you have merged into
your tree a version of the driver-core tree that I reported broken on Dec
28.

Presumably you merged the driver-core tree to fix up some conflicts I
have reported.  Don't do that, please.  Either leave them for Linus to
fix up, or do a merge of Linus' tree after he has merged the (hopefully
fixed) driver-core tree during the merge window. Or send him your tree
unmerged with the merged version available for him to use if he wants to.

I have used the s5p tree from next-20111228 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_Jan_2012_18_08_54_+1100_dBBZIUY0H9Ll6HtI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAqmGAAoJEECxmPOUX5FEYVMQAI+uPy7yED9DKQISd9O66WOg
OSI8iDonqS234UFRaLqNVq/G9Qb2qdVWW/7AE+EmuyW7MEFw249mC+x0kTlPDATY
AcfVQ/M5YvQW5z+8sTNAEihiVr808SsJ6HRKVgjAMXCHmN8Vx0hInR42JpvLc8Nu
JGTB08juPuhKo2XdgyjN9bkP1v/4DlLXIikp6wK7/zubshGpY+T0Z9FL58EOufyq
uShFRmLxaIF04M0SfJVAuXdpBV/C7URriVXw72j0OXbKhOr5qsy2Hm/1HidWx3Am
0btMKIRDnk6HvXv+EyaafZP23stkawYSxvDClUllL1C0VlJtBPG4g9323GRqnwsd
OxtRDDUwU4zJpj1BlOTD3apceVYWfWidwL3NuPY/tclOXyD37GWyahyQKeWxEoCd
pEBNeDUEU1L7ZES/HFsvaOdn9M25+wmRLgaJq+j4gi2IPUif01q3ZvIcOowxos5u
5iQUdc8xZkBW6kY6iMHtnE9mgwh39/aJkECu3l8j88cuVj1BeEWyx8BBgkDP4hOJ
n5WDpwjkBNDK68dJKdG4+J9qcqMYUj4L6t/3CtYBBK239ojdjuL/3IAjZs8rBV+S
+7lYBek6XT56/oENHDhL39P76tg8I1ua1YbxXZUsVqjknh3cdVCqq/UglZBSsRGo
88XatwlVrMgQZUdbetGF
=hfDj
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_18_08_54_+1100_dBBZIUY0H9Ll6HtI--
