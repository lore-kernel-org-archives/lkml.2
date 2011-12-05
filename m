Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab1LEGzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 01:55:19 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:61905 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1LEGzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 01:55:17 -0500
Date: Mon, 5 Dec 2011 09:55:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] staging: vt6656: aes_ccmp, baseband, bssdb, card:
 Change BOOL to int
Message-ID: <20111205065517.GC3236@mwanda>
References: <1323047566-12650-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <1323047566-12650-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EDC6AD0.0072,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 04, 2011 at 11:12:46PM -0200, Marcos Paulo de Souza wrote:
> This patch change all references of BOOL to int. As asked by the TODO
> file of the driver, we need to remove the ttype.h, and this file do a
> typedef of int to BOOL. We don't need this.
>=20

Why not use bool?  Especially inside structs bool takes up less
space than an int.  Also static analysis tools care about the type.

Changing the type from int to bool is a code change so it needs
careful auditing.  It's not a problem if you don't have this
hardware, but you've been sending quite a few patches for it, so I'm
curious if you do?  If you did, and you made a code change then it
helps us to know if you have tested it.

regards,
dan carpenter


--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3GrVAAoJEOnZkXI/YHqRdwcP/3yMpCYev1CQY39JDDc197cg
/528/TQE+of1GcUzVBqfzFGbgEb+EKHRuM85sOC7GKulezeK62cezn1S4U6BuHwn
sMOaaG3JNe0Y5TMFuoF417lOzg0Hn83ybqSS3aHELFFaQ6VhL7Zbow2lUjHTlhtw
MUQq+MWxnE+MUcnpRbdr9zlCbevz/3/44Niuo+4MjtJzDj24QLvBUwgN3rb0NG44
wGst4SmPtlNFwy1pR9pylzWE38UnjB28ix+DbbcXR+bPoeHFEggD38eKHY6fwZZp
4w8QTd37rNLrcXn9Rkko+X6n0M4mzFr01ePMwrUebT0y8uSMNLIRPcuygJrgp90A
FnnXVNtAp/GPgP3iqK7x+1aYogzK0mUn8OEyqNQjWoPnUDFdMxkzBkXBBIubjY2m
OpOQG/+cPxMzszL6xHrUQaEWe9dl8yWFlGrlDFDWH4HOOPxjF6cnqxOIngi9RHNJ
noZNjfaY6u7y+KMAP4y2hDq4yNhbaeG1FhkinynFf+agwj3IHnXa1pzV+tzjwGzS
u7Gag/xZ6QKRGNwCJXqyJoYQvAWpDiIlpDOoWGx8HmqqydanLgMlAMlTq+Xgmfz8
+bOdI7Fwha3AJJpWHX6PC9XtLbRYs3k2vjX/SaZBKO6FcMzeOce3ODAjf3I3g3hd
jG/cj65g4MglpA+reZqk
=B1wD
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
