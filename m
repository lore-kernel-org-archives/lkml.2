Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1JOT1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:27:04 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54038 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1JOT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:27:02 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Richard Weinberger <richard@nod.at>
Cc: mfasheh@suse.com, jlbec@evilplan.org, ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OCFS2 1.6.0 for mainline?
In-Reply-To: Your message of "Sat, 15 Oct 2011 19:49:43 +0200."
             <4E99C7B7.5060405@nod.at>
From: Valdis.Kletnieks@vt.edu
References: <4E99A8F3.50206@nod.at> <30236.1318700758@turing-police.cc.vt.edu>
            <4E99C7B7.5060405@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318706796_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 15 Oct 2011 15:26:36 -0400
Message-ID: <33629.1318706796@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4E99DE78.00D8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318706796_3703P
Content-Type: text/plain; charset=us-ascii

On Sat, 15 Oct 2011 19:49:43 +0200, Richard Weinberger said:

> Am 15.10.2011 19:45, schrieb Valdis.Kletnieks@vt.edu:
> > On Sat, 15 Oct 2011 17:38:27 +0200, Richard Weinberger said:

> >> http://oss.oracle.com/projects/ocfs2/source.html states:
> >> "Active development on OCFS2 happens in the mainline kernel."

> > Put differently, why do you think 1.6.0 is available?

> OCFS2 1.6.3-1 and OCFS2 Tools 1.6.3-1 are the latest versions. The new
> features available in this release include Extended Attributes, POSIX
> ACLs, REFLINKs, Indexed Directories, Allocation Reservation, Metadata
> Checksums and User/Group Quotas."

Nice feature list, I can see why you want it. ;)

> Looks like it's only available for "Unbreakable Linux" subscribers.
> The development seems to be detached from mainline. :-(

Well, you have to admit it *is* an interesting business model - giving release
N to your customers and N-1 to the world.  I just got totally mislead by the
quote from the Oracle site that said the development happens in mainline. ;)


--==_Exmh_1318706796_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOmd5scC3lWbTT17ARAotDAJ4zYSKlDJymiOK847B8CobInEmdPQCgtoY9
ZOeTnDMxOgC+yXsp6PSQokM=
=n8+M
-----END PGP SIGNATURE-----

--==_Exmh_1318706796_3703P--

