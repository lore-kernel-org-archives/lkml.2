Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1JOV0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:26:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51788 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1JOV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:26:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Richard Weinberger <richard@nod.at>
Cc: Kyle Moffett <kyle@moffetthome.net>, mfasheh@suse.com, jlbec@evilplan.org,
        ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        license-violation@gpl-violations.org
Subject: Re: OCFS2 1.6.0 for mainline?
In-Reply-To: Your message of "Sat, 15 Oct 2011 23:12:44 +0200."
             <4E99F74C.80900@nod.at>
From: Valdis.Kletnieks@vt.edu
References: <4E99A8F3.50206@nod.at> <30236.1318700758@turing-police.cc.vt.edu> <4E99C7B7.5060405@nod.at> <33629.1318706796@turing-police.cc.vt.edu> <CAGZ=bqJb5FGJe264TOtfuzm8dyvWO883NFBnzkyA4M6Fe7Nq_g@mail.gmail.com>
            <4E99F74C.80900@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318713935_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 15 Oct 2011 17:25:35 -0400
Message-ID: <37252.1318713935@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E99FA65.0018,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318713935_3703P
Content-Type: text/plain; charset=us-ascii

On Sat, 15 Oct 2011 23:12:44 +0200, Richard Weinberger said:
> Am 15.10.2011 23:03, schrieb Kyle Moffett:
> > If someone who has a copy of Oracle's "Unbreakable Linux" can get
> > ahold of the sources, please put them in GIT somewhere for the rest of
> > us to access; it *is* GPLed software after all.  Otherwise, please
> > distribute the binaries to the rest of us and we will obtain the
> > sources on our own.  I can't find any published information on their
> > website about how to obtain the sources, so someone will have to
> > contact them directly.

Remember that Oracle only has an obligation to give source to the people *they*
give binaries to.  If you get binaries from an Oracle customer, you'll have to
hit that customer up for the corresponding source.

> I found this src.rpm:
> http://public-yum.oracle.com/repo/OracleLinux/OL6/1/base/x86_64/kernel-ue=
> k-2.6.32-100.34.1.el6uek.src.rpm
> 
> linux-2.6.32/fs/ocfs2 contains OCFS2 1.6.3.
> 
> Mark, Joel, can you please port this "release" to mainline?

I'll bite.. what's an acceptable Signed-Off-By: chain if somebody is pushing
somebody else's GPL'ed code upstream?  I seem to remember some maintainers
being a tad prickly about this case in the past?


--==_Exmh_1318713935_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOmfpPcC3lWbTT17ARAmW8AKCvYmyaEPH451bDEA/fXEWBu1h2kwCeL16b
TJ+GX3DpqQWymNGW/vjHDN8=
=aaoR
-----END PGP SIGNATURE-----

--==_Exmh_1318713935_3703P--

