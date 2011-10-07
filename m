Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235Ab1JGQYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:24:11 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59725 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135Ab1JGQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Josh Boyer <jwboyer@gmail.com>
Cc: Frank Mehnert <frank.mehnert@oracle.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Subject: Re: RFC: virtualbox tainting.
In-Reply-To: Your message of "Fri, 07 Oct 2011 11:16:13 EDT."
             <CA+5PVA4v0D_ppnjN_k_6AcDEfH_U0Nn9WLfb3J84JGBGBOFBsg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20111006190526.GA13883@redhat.com> <201110071640.53827.frank.mehnert@oracle.com>
            <CA+5PVA4v0D_ppnjN_k_6AcDEfH_U0Nn9WLfb3J84JGBGBOFBsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1318004546_9306P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Oct 2011 12:22:26 -0400
Message-ID: <14824.1318004546@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E8F2745.013D,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1318004546_9306P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Oct 2011 11:16:13 EDT, Josh Boyer said:
> In all seriousness, is there a reason these modules haven't been
> submitted to the staging tree?  Perhaps this was attempted in the past
> and I'm just not finding references to it.

I haven't actually checked what the churn rate of the kernel side of VirtualBox is, but
there *is* some benefit if you have a package that includes both userspace and kernel
code, to keep them in sync.

Currently, VirtualBox is at 4.1.4.  Now, if they decide they need to change/fix/extend
the API for some reason, they can just ship a 4.1.6 and be happy.  If the code is
in-tree, then they are basically stuck with the API - they can't ship a 4.1.6 that can
get away with assuming that all the kernel API is there.  So you have to carry around
workarounds and test-for-features code and all that stuff.

I don't know - maybe the Oracle crew think the API is stable enough now that they can
afford to do that.  But Frank would probably be the one to speak to how in/out of tree
would affect their development/support methodology.


--==_Exmh_1318004546_9306P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOjydCcC3lWbTT17ARAhACAJ4kOr0mOeBwGjMmnja/wneER9iSlACgji4V
A+ncHqXDTqCX8tEu8IbWFYY=
=bDTz
-----END PGP SIGNATURE-----

--==_Exmh_1318004546_9306P--

