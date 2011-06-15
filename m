Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1FOTpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:45:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52348 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab1FOTpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:45:02 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: pageexec@freemail.hu
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
In-Reply-To: Your message of "Tue, 14 Jun 2011 02:48:35 +0200."
             <4DF6AFE3.11023.3919B397@pageexec.freemail.hu>
From: Valdis.Kletnieks@vt.edu
References: <cover.1307292171.git.luto@mit.edu> <4DEEB31B.24457.19E64984@pageexec.freemail.hu> <20110610111932.GA30987@elte.hu>
            <4DF6AFE3.11023.3919B397@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1308166946_2757P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Jun 2011 15:42:26 -0400
Message-ID: <35746.1308166946@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DF90B28.0074,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1308166946_2757P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Jun 2011 02:48:35 +0200, pageexec@freemail.hu said:
> > It makes it distinctly *easier*: people will update their systems
> > based on a list of say 10 CVEs that affect them, totally blind to the
> > 100+ other bugs that may (or may not) have an effect on them. 
>
> 'people' are not updating their systems based on any list. 'people' update their
> systems based on what their kernel supplier (vendor/distro/company's internal
> team/etc) provides them with (there's an extreme minority of users who build
> their own kernels of the latest vanilla tree).
>
> now the big question becomes whether these suppliers are helped or obstructed by
> your policy of covering up security fixes. given that pretty much none of them
> supports the latest vanilla tree, not even -stable, it means that in order to
> release new kernels they'll have to backport fixes. fixes that they don't even
> know they should be backporting because of your covering them up. so what happens
> is that everyone has to read every commit and do his best estimate whether it's
> worthy of backporting or not (notice the waste of duplicated effort). don't you
> think they could spend more time on finding actually important fixes if they
> could skip over the already known ones and just backport them?

You point out that "people" don't do updates based on the list - but then
recommend that *vendors* base their updates on the same list for the same
reasons. So instead of a user at risk, now it's every customer of a vendor at
risk, because the *vendor* will just cherry-pick the fixes labelled "security".
The vendor *still* has to go through the entire pile of fixes *anyhow*, because
we already *know* that we may fail to recognize that a fix is
security-relevant. So cherry-picking "security" is doing the customers a
dis-service.

Second, the vendor's engineers *still* have to go through all the fixes
*anyhow*, because in the *real world*, "security" is *not* the only thing -
it's *one small piece*.  A vendor's customers don't really care if the vendor
includes a fix for some hard-to-exploit kernel hole if the vendor fails to ship
the patch that keeps the fiberchannel controller card from locking up the
system, or the patch that makes MySQL not SEGV, or the patch that fixes dropped
characters on the tty line their data aquisition system uses, or the patch that
keeps the filesystem from corrupting directories because of a bad refcount.

If the system *does not work*, customers *don't care* about its security.  And
you're going to have a hard time if you keep trying to sell your "security is
everything" viewpoint to people who have to support systems where security is
only one piece of it.


--==_Exmh_1308166946_2757P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN+QsicC3lWbTT17ARAkOcAJ9HfV1MTbdN/dedaU+B5q/5sSVJVgCgnnG/
Ymxkb9MbqlnZir1JGvmojT8=
=MZxn
-----END PGP SIGNATURE-----

--==_Exmh_1308166946_2757P--

