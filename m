Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1ISUBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:01:07 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:58191 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1ISUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:01:05 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Christoph Lameter <cl@gentwo.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
In-Reply-To: Your message of "Mon, 19 Sep 2011 12:51:10 CDT."
             <alpine.DEB.2.00.1109191249450.10968@router.home>
From: Valdis.Kletnieks@vt.edu
References: <20110910164134.GA2442@albatros> <20110914192744.GC4529@outflux.net> <20110918170512.GA2351@albatros> <CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com> <20110919144657.GA5928@albatros> <CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com> <20110919155718.GB16272@albatros> <CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com> <20110919161837.GA2232@albatros> <CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com> <20110919173539.GA3751@albatros>
            <alpine.DEB.2.00.1109191249450.10968@router.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316462369_2864P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Sep 2011 15:59:29 -0400
Message-ID: <14587.1316462369@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E779F23.0037,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316462369_2864P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Sep 2011 12:51:10 CDT, Christoph Lameter said:

> IMHO a restriction of access to slab statistics is reasonable in a
> hardened environment. Make it dependent on CONFIG_SECURITY or some such
> thing?

Probably need to invent a separate Kconfig variable - CONFIG_SECURITY
is probably a way-too-big hammer for this nail. I can see lots of systems
that want to enable that, but won't want to tighten access to slab.

--==_Exmh_1316462369_2864P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOd58hcC3lWbTT17ARAqntAJ9nYtezmYHd08LlkuKPs0uyZJ7ArQCg8ojt
AjsVuiufiH0yJvS+zXTlfWI=
=Mc3V
-----END PGP SIGNATURE-----

--==_Exmh_1316462369_2864P--

