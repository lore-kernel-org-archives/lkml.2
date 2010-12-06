Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0LFCiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:38:01 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43413 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0LFCh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:37:56 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Theodore Tso <tytso@MIT.EDU>
Cc: device-mapper development <dm-devel@redhat.com>,
        Heinz Diehl <htd@fritha.org>, Jon Nelson <jnelson@jamponi.net>,
        htejun@gmail.com, Matt <jackdachef@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
        htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
In-Reply-To: Your message of "Sun, 05 Dec 2010 08:24:32 EST."
             <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com> <20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com> <20101205100954.GA6564@fritha.org> <4CFB679D.5030900@redhat.com>
            <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291603044_67929P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 05 Dec 2010 21:37:25 -0500
Message-ID: <206035.1291603045@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4CFC4C6A.004F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291603044_67929P
Content-Type: text/plain; charset=us-ascii

On Sun, 05 Dec 2010 08:24:32 EST, Theodore Tso said:

> I've been using a kernel which is between 2.6.37-rc2 and -rc3 with a LUKS /
> dm-crypt / LVM / ext4 setup for my primary file systems, and I haven't observed
> any corruption for the last two weeks or so.

Pretty much exactly the same setup here (LUKS/dm-crypt/LVM/ext4), pretty
consistently running most-recent mmotm kernel, which tends to be somewhat ahead
of linux-next, and I haven't seen anything either. (I admit I haven't tried
-rc4-mmotm1202 yet).

> As another thought, what version of GCC 

rpm -q says 'gcc-4.5.1-5.fc15.x86_64'.  

--==_Exmh_1291603044_67929P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM/ExkcC3lWbTT17ARAqOlAJ0Z49Sd/WnIe419LFzFShCJb+zIjQCg2Dmy
Ot+wazgEszexzIvWmrvcvR4=
=1D7I
-----END PGP SIGNATURE-----

--==_Exmh_1291603044_67929P--

