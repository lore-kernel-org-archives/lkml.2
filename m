Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0D0NtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:49:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49394 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab0D0NtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:49:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, stefanha@linux.vnet.ibm.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Fix libdw-dev package name in error message
In-Reply-To: Your message of "Tue, 27 Apr 2010 12:59:19 -0000."
             <tip-f93830fbb06b67848c762f2177c06cc3cbb97deb@git.kernel.org>
From: Valdis.Kletnieks@vt.edu
References: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
            <tip-f93830fbb06b67848c762f2177c06cc3cbb97deb@git.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272376100_4032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Apr 2010 09:48:20 -0400
Message-ID: <5694.1272376100@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4BD6EB25.0082,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272376100_4032P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Apr 2010 12:59:19 -0000, tip-bot for Stefan Hajnoczi said:
> Commit-ID:  f93830fbb06b67848c762f2177c06cc3cbb97deb
> Gitweb:     http://git.kernel.org/tip/f93830fbb06b67848c762f2177c06cc3cbb97deb
> Author:     Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> AuthorDate: Mon, 26 Apr 2010 15:39:54 -0300
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon, 26 Apr 2010 15:39:54 -0300
> 
> perf tools: Fix libdw-dev package name in error message
> 
> The headers required for DWARF support are provided by the libdw-dev
> package in Debian-based distros.

Not all the world is Debian based.  As I mentioned before, the package needed
is elfutils-devel on Redhat/Fedora systesm.  For those boxes, you're changing a
'elfutil-dev' that the user can guess is supposed to be -devel, to a package
that doesn't exist on Redhat/Fedora.  And to compound it, if the user guesses
that you meant libdwarf-devel, that still fails, because that does *not*
provide the libdw.h header - that's still in elfutil-devel.


--==_Exmh_1272376100_4032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL1uskcC3lWbTT17ARAvhUAKDXeuLVFvt5hiLh2ByEHj1UzOehjQCdEr8R
hR/MEzZd63KMwi0Bb9Z8XGs=
=xUru
-----END PGP SIGNATURE-----

--==_Exmh_1272376100_4032P--

