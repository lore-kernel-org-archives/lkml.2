Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1I2Qs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:48:57 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41738 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1I2Qs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:48:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 00/11] virtio: Support for hibernation (S4)
In-Reply-To: Your message of "Thu, 29 Sep 2011 21:19:25 +0530."
             <20110929154925.GG3708@amit-x200.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <cover.1317309123.git.amit.shah@redhat.com>
            <20110929154925.GG3708@amit-x200.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317314927_4004P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Sep 2011 12:48:47 -0400
Message-ID: <23581.1317314927@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E84A170.00DD,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317314927_4004P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Sep 2011 21:19:25 +0530, Amit Shah said:
> On (Thu) 29 Sep 2011 [20:55:56], Amit Shah wrote:
> > Hello,
> > 
> > These patches add support for S4 to virtio (pci) and all drivers.  The
> > patches are based on the virtio-console patch series in Rusty's queue.
> 
> Some patches have checkpatch warnings, re-sending those as v2.

When doing something like this, don't say "some" - say "patches 4,5, 6, and 9".
Otherwise we're looking at 11 patches from the first set, 4 replacements, and
no way to tell if we've missed a 5th replacement patch.


--==_Exmh_1317314927_4004P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOhKFvcC3lWbTT17ARAv7KAJwLPRUNeVgdO5wAD+Dk1DzhLcmhawCgzx6X
1swTP9zma0b2TqZo8CPpu1I=
=fpck
-----END PGP SIGNATURE-----

--==_Exmh_1317314927_4004P--

