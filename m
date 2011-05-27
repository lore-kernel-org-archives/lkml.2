Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1E0WNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:13:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54278 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab1E0WNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:13:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Olivier Galibert <galibert@pobox.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
In-Reply-To: Your message of "Fri, 27 May 2011 23:51:23 +0200."
             <20110527215123.GA45133@dspnet.fr>
From: Valdis.Kletnieks@vt.edu
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu> <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu> <BANLkTimGQh7P9O+BEd85Wm5iqzWg5DuYYg@mail.gmail.com> <20110527181724.GA6485@elte.hu>
            <20110527215123.GA45133@dspnet.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306534308_2736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 27 May 2011 18:11:48 -0400
Message-ID: <26238.1306534308@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Status: score=50/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=bulk(0),
	refid=str=0001.0A02020A.4DE021A6.0088,ss=3,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306534308_2736P
Content-Type: text/plain; charset=us-ascii

On Fri, 27 May 2011 23:51:23 +0200, Olivier Galibert said:
> On Fri, May 27, 2011 at 08:17:24PM +0200, Ingo Molnar wrote:
> >  - A root exploit will still not give away the location of the
> >    kernel (assuming module loading has been disabled after bootup),
> >    so a rootkit cannot be installed 'silently' on the system, into
> >    RAM only, evading most offline-storage-checking tools.
> > 
> >    With static linking this is not possible: reading the kernel image
> >    as root trivially exposes the kernel's location.
> 
> There's something I don't get there.  If you managed to escalate your
> priviledges enough that you have physical ram access, there's a
> billion things you can do to find the kernel, including vector
> tracing, pattern matching, looking at the page tables, etc.

Oh, you mean all the tricks that people do now to patch the syscall table
once we hid it so they couldn't patch it? :)

--==_Exmh_1306534308_2736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN4CGkcC3lWbTT17ARAgMyAJ97oprAuzC2Ls3e1lb9ON9e3VF9fQCgr6pt
/2eWD2ETfrWxQpCaKuYUrT4=
=Eglt
-----END PGP SIGNATURE-----

--==_Exmh_1306534308_2736P--

