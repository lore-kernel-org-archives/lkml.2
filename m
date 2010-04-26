Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0DZQd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 12:33:29 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46132 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0DZQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 12:33:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf: Fix libdw-dev package name in error message
In-Reply-To: Your message of "Mon, 26 Apr 2010 15:27:03 BST."
             <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272299568_4063P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Apr 2010 12:32:48 -0400
Message-ID: <10222.1272299568@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4BD5C034.02BE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272299568_4063P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Apr 2010 15:27:03 BST, Stefan Hajnoczi said:
> The headers required for DWARF support are provided by the libdw-dev
> package in Debian-based distros.  This patch corrects the elfutils-dev
> package name to libdw-dev in the Makefile error message when libdw.h is
> not found.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> ---
> I don't think any distro has an elfutils-dev package but the name was chosen 
> because of the usual RedHat/Debian -devel/-dev convention.

elfutils-dev is wrong, elfutils-devel is right, at least for Fedora.

% repoquery -ql elfutils-devel.x86_64
/usr/include/dwarf.h
/usr/include/elfutils
/usr/include/elfutils/elf-knowledge.h
/usr/include/elfutils/libasm.h
/usr/include/elfutils/libdw.h
/usr/include/elfutils/libdwfl.h
/usr/include/elfutils/libebl.h
/usr/include/elfutils/version.h
/usr/lib64/libasm.so
/usr/lib64/libdw.so
/usr/lib64/libebl.a


--==_Exmh_1272299568_4063P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL1cAwcC3lWbTT17ARAlgsAKC73EkpiefrjCl2+JBpMODOi5KNmACg4MiO
062h0fxe2UOXfJiaB1Z/2UI=
=vBdQ
-----END PGP SIGNATURE-----

--==_Exmh_1272299568_4063P--

