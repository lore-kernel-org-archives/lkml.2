Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2DPKhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:37:34 -0400
Received: from edge2.cs.stonybrook.edu ([130.245.9.211]:40635 "EHLO
	edge2.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2DPKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:37:33 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 06:37:32 EDT
Message-ID: <4F8BF514.509@cs.stonybrook.edu>
Date: Mon, 16 Apr 2012 06:31:48 -0400
From: Richard Yao <ryao@cs.stonybrook.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120406 Thunderbird/10.0.3
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: How do I detect a block device is being used as swap inside its request
 queue handler?
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig114FB102E20AD7EF329D8DA1"
X-Originating-IP: [72.89.250.133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig114FB102E20AD7EF329D8DA1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dear Linus Torvalds et al,

I am having some trouble with an out of tree module for a virtual block
device driver. I need to disable the direct reclaim path when the device
is used as swap. I cannot see a way to detect that the device is being
used as swap, so I am currently disabling it unconditionally.

Is there a clean way to detect that the block device is being used as
swap? I am not subscribed to the list, so please CC replies to me.

Yours truly,
Richard Yao


--------------enig114FB102E20AD7EF329D8DA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPi/UZAAoJELFAT5FmjZuEi6EP/1jR0l1x/mB2h1pOFqtTPVf4
iwgN1jt3zHZnHpv56NPE1IxAtK1YJJt/Z4ZKv4QcffBBwfOLiMFCpN6X2w7vptzK
3g3EoFFAwEsOm4lRdrreguy2Gw9hOPcAXa5G4Z+iZNkfOjblkjkocDSL1nn3VlHf
Yn34OnS57YP0Gm197lAK2uSq8fOcGg/jmv6wW6COlDhpdfwGGz7FPKH2oOHqxtVP
m8+Yjb3EZgGif8pW5Z5XetpA8BQtKJddIZZjdSsJRI6VVkOGdiwDQq9ED9QZCryW
hl4bC6ECQAXEzzqg8qchDLaaKjZG1wcuWX76lxWvcxybKoNq/G1N/SVaqBE22B5P
4H6NNgLJfEclkj/oBW8dC9b50PUvoINkRhYy9muOmomCCzEfzvRTpews09RUlwyh
BoMRavjZeMHj2Uqm9KoAvBK+T2WF8PSvz8XAQSYc5+3HasN1Uifh5vWogHcdgBin
LRwSWrAwOjqS2rqOTt5vvrHWr5uPAcMEt4P0qK92Nq6YFiCXD8h6hkwDFr1fZvYJ
ZBPu80x/btJGi8nGO8Fv5nWC5DFQ0mGO+hGHidZIclu1ZdArW7/eEJwMH526gnaT
DD8Ub0Qn6Md9kvH7zQHn8Neqg/FQcJ5feePKjB7o13K0dq3XD0g6IgUBUV4el+NC
W8juFCGVPgl001m1nte3
=WRks
-----END PGP SIGNATURE-----

--------------enig114FB102E20AD7EF329D8DA1--
