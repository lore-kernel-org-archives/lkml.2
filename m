Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0FUCRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:17:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45713 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541Ab0FUCRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:17:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: James Morris <jmorris@namei.org>
Cc: Theodore Tso <tytso@mit.edu>, Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kees Cook <kees.cook@canonical.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
In-Reply-To: Your message of "Mon, 21 Jun 2010 10:52:11 +1000."
             <alpine.LRH.2.00.1006211038250.7537@tundra.namei.org>
From: Valdis.Kletnieks@vt.edu
References: <20100616221833.GM24749@outflux.net> <20100617000120.13071be8@lxorguk.ukuu.org.uk> <20100616232230.GP24749@outflux.net> <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org> <20100617170453.GV24749@outflux.net> <20100617215349.2fac02f5@lxorguk.ukuu.org.uk> <20100617140630.c6ced27a.rdunlap@xenotime.net> <20100617221815.68ce30c5@lxorguk.ukuu.org.uk> <20100617215105.GB24749@outflux.net> <20100617233054.330256cf@lxorguk.ukuu.org.uk> <4C1AE3A8.2020104@schaufler-ca.com> <E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu>
            <alpine.LRH.2.00.1006211038250.7537@tundra.namei.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1277086573_2259P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 20 Jun 2010 22:16:13 -0400
Message-ID: <92911.1277086573@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4C1ECB71.01B1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1277086573_2259P
Content-Type: text/plain; charset=us-ascii

On Mon, 21 Jun 2010 10:52:11 +1000, James Morris said:

> Note that people using SELinux or AppArmor already have the ability to 
> restrict ptrace, and they would thus not need to stack this function if it 
> were in a separate LSM.

That's assuming they can figure out how to write and integrate the required
policy changes. Looking inside selinux-policy-3.8.3-4.fc14.src.rpm from Fedora
Rawhide: (Holy cow, there's a .git tree in that tarball - no wonder it's 20M in
size).

% cd serefpolicy-3.8.3/policy/modules; wc -l */* | grep total
 135967 total

135kloc of policy that probably nobody in your shop really understands.  At
that point, writing something that stacks starts sounding really enticing.



--==_Exmh_1277086573_2259P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMHsttcC3lWbTT17ARAiqaAKCMUNWTvSr1LDJxQafdS6OH/Er70QCgoWq8
t1cXzeI4EtbX6H8LD7YeBcs=
=4C28
-----END PGP SIGNATURE-----

--==_Exmh_1277086573_2259P--

