Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1JEEXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:23:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59988 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1JEEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:23:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Adrian Bunk <bunk@stusta.de>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Wed, 05 Oct 2011 01:39:32 +0300."
             <20111004223932.GA3460@localhost.pp.htv.fi>
From: Valdis.Kletnieks@vt.edu
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi> <34045.1317760188@turing-police.cc.vt.edu>
            <20111004223932.GA3460@localhost.pp.htv.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317788584_4646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Oct 2011 00:23:04 -0400
Message-ID: <12780.1317788584@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E8BDBAD.0038,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317788584_4646P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Oct 2011 01:39:32 +0300, Adrian Bunk said:

> But the semantics of PGP key signing is that you certify that you 
> verified that a photo ID of that person matches the name on the key.

No. The semantics are that you've verified the person matches the key.
Photo ID's are *one way* of doing it.

http://www.gnupg.org/gph/en/manual.html 

The GNU Privacy Handbook says (under 'Importing a Public Key'):

"A key's fingerprint is verified with the key's owner. This may be done in
person or over the phone or through any other means as long as you can
guarantee that you are communicating with the key's true owner. If the
fingerprint you get is the same as the fingerprint the key's owner gets, then
you can be sure that you have a correct copy of the key."

Now, if you're doing a PGP keysigning, then yes, checking government-issued ID
is probably the only sane way to verify 50 or 100 people's identities in an
hour. But if you have other trustable channels of doing so, that's considerd OK
too.


--==_Exmh_1317788584_4646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOi9uocC3lWbTT17ARAo9RAKC837tgsg/HsqbB9ASHD0thvHg/gQCg10z2
vHFbSjSpOA524LMefwx6A4U=
=BtIn
-----END PGP SIGNATURE-----

--==_Exmh_1317788584_4646P--

