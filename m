Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0G1MgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:36:12 -0400
Received: from csamuel.org ([74.50.50.137]:40728 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0G1MgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:36:08 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2010 08:36:08 EDT
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Date: Wed, 28 Jul 2010 22:28:19 +1000
User-Agent: KMail/1.13.5 (Linux/2.6.32-24-generic; KDE/4.4.92; x86_64; ; )
Cc: Ben Chociej <bchociej@gmail.com>, diegocg@gmail.com,
        chris.mason@oracle.com, linux-fsdevel@vger.kernel.org, cmm@us.ibm.com,
        bcchocie@us.ibm.com, mrlupfer@us.ibm.com, crscott@us.ibm.com,
        linux-kernel@vger.kernel.org
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com> <201007280110.46059.diegocg@gmail.com> <AANLkTi=x9q1XOu_6F2hOv_ZPoM+McKz9Nv2Q5GZNfa4a@mail.gmail.com>
In-Reply-To: <AANLkTi=x9q1XOu_6F2hOv_ZPoM+McKz9Nv2Q5GZNfa4a@mail.gmail.com>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18833409.WfW9mxhoo8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007282228.23360.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18833409.WfW9mxhoo8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Jul 2010 09:18:23 am Ben Chociej wrote:

> Yes, that's correct. It's likely not going to be a cache in the
> traditional sense, since the entire capacity of both HDD and SSD would
> be available.

To me that sounds like an HSM type arrangement, with most frequently used d=
ata=20
on the highest performing media and less frequently touched data getting=20
shunted down the chain to SAS, SATA and then tape and/or MAID type devices.

Certainly interesting from my HPC point of view in that I can see it being=
=20
useful to parallel filesystems like Ceph if this "just happens".

I guess real HSM devotees would want policies for migration downstream.. ;-)

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart18833409.WfW9mxhoo8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATFAiZI1yjaOTJg85AQKgIAgAmSg0l/BcxEJEUTLWmZbKecFUdmbanuFM
ugN4G6xY/VItX5HIJmNfLtorciSBMCmHTtFelKs/FPTRIozIv3Pe7/8AZl0rCi+0
RiM+S2D15oIFyLYOKlxzh0TK4NjS+kW/Xa1xLlNdQtW77jtLZqJaSldK1n15X0Ls
YwTdPRp63R3TfWqLkuPpN+M0aJmo5YfkKDyUDukSs/dEinVRQEKQZ2+oyie92Gd+
ZbIeXKJX2q1SZ6oM+4+oiL5R6sXESdEJ5IjqhkXE0FAOcPqyigPrum/pPUtymZa6
3iBbS38lwiYNDSCR6PbccRUsvstG6tFGtne+JP+dcqP4JWpJKiQriQ==
=HETq
-----END PGP SIGNATURE-----

--nextPart18833409.WfW9mxhoo8--
