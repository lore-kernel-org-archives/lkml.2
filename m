Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0FGQUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:20:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36186 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0FGQUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:20:50 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kees Cook <kees.cook@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
In-Reply-To: Your message of "Thu, 03 Jun 2010 14:00:51 PDT."
             <20100603210051.GD4714@outflux.net>
From: Valdis.Kletnieks@vt.edu
References: <20100603080158.GE4971@outflux.net> <m11vcnlw9j.fsf@fess.ebiederm.org>
            <20100603210051.GD4714@outflux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1275927536_5370P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jun 2010 12:18:56 -0400
Message-ID: <6305.1275927536@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4C0D1BF3.0008,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1275927536_5370P
Content-Type: text/plain; charset=us-ascii

(Sorry for the late reply, didn't have time last few days to drink from the
lkml firehose)

On Thu, 03 Jun 2010 14:00:51 PDT, Kees Cook said:
> On Thu, Jun 03, 2010 at 01:02:48PM -0700, Eric W. Biederman wrote:
> > Kees Cook <kees.cook@canonical.com> writes:
> > > A long-standing class of security issues is the symlink-based
> > > time-of-check-time-of-use race, most commonly seen in world-writable
> > > directories like /tmp. The common method of exploitation of this flaw
> > 
> > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > This approach to fix the problem to of /tmp looks to me like it
> > will have the opposite effect.  I think this patch will encourage
> > more badly written applications.
> 
> How to safely deal with /tmp has been well understood for well over
> a decade.  I don't think this change would "encourage" poor code.

The fact that you're proposing this patch a decade after we "well understood"
the problem should suggest that it *will* encourage poor code, as the same
programmers who don't currently get it right (and are thus the targets of your
patch) will quite likely just say "Oh, I saw a patch for that, I don't have to
try to do it right..."


--==_Exmh_1275927536_5370P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMDRvwcC3lWbTT17ARAg6lAKC1YxmfTY/YrPv8q9dAOOAXvBiPEACgxl1h
4raLs0Y4zxRRkDuV49hqMYQ=
=O+1e
-----END PGP SIGNATURE-----

--==_Exmh_1275927536_5370P--

