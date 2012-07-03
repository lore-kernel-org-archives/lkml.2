Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2GCI7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:59:43 -0400
Received: from gold.linx.net ([195.66.232.40]:37833 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab2GCI7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:59:40 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2012 04:59:40 EDT
Message-ID: <4FF2B263.4080000@linx.net>
Date: Tue, 03 Jul 2012 09:50:43 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120607 Thunderbird/13.0
MIME-Version: 1.0
To: Michael Chan <mchan@broadcom.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Anthony G. Basile" <basile@virtual.dyc.edu>
Subject: BNX2 MIPS06 firmware in tree is 6.2.1, driver wants 6.2.3
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Good morning,

As of mainline commit c2c20ef43d00b1439631e603f8dcee9a803cd8b3 in
December 2011, the BNX2 driver requests bnx2/bnx2-mips-06-6.2.3.fw;
however the firmware/bnx2 directory in the kernel sources only
contains bnx2/bnx2-mips-06-6.2.1.fw so the call fails.

The network interfaces will not come up at all, making it necessary to
steal & rename 6.2.1 firmware to get the interfaces up, and then
install a linux-firmware tarball. Before this commit, the bnx2 driver
as compiled was self-sufficient.

Would it be possible to get back to this situation by updating the
relevant firmware/bnx2 files in the kernel sources please? I noticed
this problem in an upgrade from 3.2.11 to 3.4.2, but I verified it is
still an issue in mainline today.

Regards,
- -- 
Tony Vroon
Server systems manager
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/ysmMACgkQp5vW4rUFj5oIpQCcClnaGH3ZTEGfqOuDCQ05wxUD
43cAoL6KJH8zmbY+UQoGedriKbcdnrbh
=3wGg
-----END PGP SIGNATURE-----
