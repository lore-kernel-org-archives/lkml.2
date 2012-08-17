Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2HQOCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:02:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:54982 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab2HQOCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:02:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,785,1336374000"; 
   d="asc'?scan'208";a="182227839"
Message-ID: <1345212408.27859.92.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: nyoushchenko@mvista.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro
Date: Fri, 17 Aug 2012 17:06:48 +0300
In-Reply-To: <20120817154332.3496d709@spider.haslach.nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	 <1345209115.27859.84.camel@sauron.fi.intel.com>
	 <20120817153348.7a0a50a0@spider.haslach.nod.at>
	 <1345210884.27859.90.camel@sauron.fi.intel.com>
	 <20120817154332.3496d709@spider.haslach.nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tZO8qLVUDU/WegQF8DQM"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tZO8qLVUDU/WegQF8DQM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 15:43 +0200, Richard Weinberger wrote:

> No, data is never added to a half-filled PEB.

OK.

> Fastmap does not share PEBs with other sub-systems by design.

It could in theory add own data to own PEBs.
--=20
Best Regards,
Artem Bityutskiy

--=-tZO8qLVUDU/WegQF8DQM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLk/4AAoJECmIfjd9wqK0f/gQAMnegYVH0h1VRexdsi1lWIpX
/o9eZ4Hd1NddSToj5uUZewN0Gay3xx6tSbXHsgE98BTU/5GxG5RvRqQNcl9Aciso
+Mu+qgGXuS8VIG2RzNpCeV58vplQoCS55q5zByLWDAbYQWSEl07PeH1oIHzW7pFF
47hYENfhgOnmhJCXzUnEt2WBeSkwUFxk30/2VRIchHEP6pGKhOJsAjrv6Hirqv0V
yszS04PZRAvVMcIA224I/4WXeG2ePOSsAeflcTGE62nSGc9tQxCXJLxUSQlnw6fK
wcUIwH0JiL9X8J+WREkjLzgzQf2an+kbn1ga25/b0vJ0zADjwrxTKIR8XDkHdkjm
yXhV8Gu+8OGRE9pxWrOvY1rMfZrD0Kki0QTFo6oPG87m7h0Ci7Osy/DKht0fyYzI
3O+Zr+dIZGvScCXFV3dwEpNow8gQBu/XrwI35xPNGutLd2ThGlc4r0YaH0rLcYfU
WenkqyFDbdaPZXdftEJ/yOxBSrg2vPldVB9AvHfZyvCnwSa2ASjjQJEua7+Unou7
YcK4SiahQ9mskAcQx94AHikz2WQIFFrPEmd+xopMjOZQyLCQutEjDSdK+A8HajVD
m7T5SMScNdlJ5+P8afRbhQayWXTnhShcH7ScErYgAq9QN56SHmTNGelrCwzF82qd
oOR90EHiVHeKR2jzHf+E
=N3N+
-----END PGP SIGNATURE-----

--=-tZO8qLVUDU/WegQF8DQM--

