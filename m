Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1DDPW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:22:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53843 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1DDPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:22:26 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: dedekind1@gmail.com
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to Makefile
In-Reply-To: Your message of "Mon, 04 Apr 2011 15:47:10 +0300."
             <1301921230.2760.79.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <1301913651-9055-1-git-send-email-dedekind1@gmail.com> <1301913651-9055-2-git-send-email-dedekind1@gmail.com> <131611.1301921158@localhost>
            <1301921230.2760.79.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1301930536_4775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Apr 2011 11:22:16 -0400
Message-ID: <7621.1301930536@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D99E22A.00CF,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1301930536_4775P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Apr 2011 15:47:10 +0300, Artem Bityutskiy said:
> On Mon, 2011-04-04 at 08:45 -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 04 Apr 2011 13:40:51 +0300, Artem Bityutskiy said:
> >
> > > 3. By default KALLSYMS_EXTRA_PASS is disabled and if kallsyms has issues,
> > >    "make" should print a warning and suggest using KALLSYMS_EXTRA_PASS
> >
> > If the Makefile has enough information to print the warning, why can't it go
> > ahead and do the extra pass itself instead of issuing the warning?
> >
> > (I'm obviously missing something here, as I'm foolishly posting to lkml before
> > caffeine ;)
>
> Good question, I thought to force people to send a bugreport.

When was the last time we actually saw such a bug report?  I'm suspecting that
all the affected people just set the variable and get on with their lives.  So
we should either just make it automatic if that's what people are going to do,
or we rip the entire "EXTRA_PASS' stuff out forcibly and *make* people fix the
actual underlying issue that causes the extra pass to be needed...


--==_Exmh_1301930536_4775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNmeIocC3lWbTT17ARAkgTAJ0YiS3ZiCts0kqYp6kAoWCT0RIF6QCg4031
KwR0Myh8oFn3GCoCNoQ7rRE=
=s7aU
-----END PGP SIGNATURE-----

--==_Exmh_1301930536_4775P--

