Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab1D1SAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:00:04 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48531 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab1D1SAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:00:02 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Michal Marek <mmarek@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3.1] kbuild: implement several W= levels
In-Reply-To: Your message of "Thu, 28 Apr 2011 18:24:46 +0200."
             <4DB994CE.40403@suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <20110422110947.GA20715@merkur.ravnborg.org> <1303494642-18594-1-git-send-email-bp@alien8.de> <20110427082555.GC5726@merkur.ravnborg.org> <20110427113513.GB18112@eferding.osrc.amd.com> <11802.1303950320@localhost>
            <4DB994CE.40403@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304013549_56837P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Apr 2011 13:59:09 -0400
Message-ID: <71633.1304013549@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A010209.4DB9AAF1.003D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304013549_56837P
Content-Type: text/plain; charset=us-ascii

On Thu, 28 Apr 2011 18:24:46 +0200, Michal Marek said:
> On 28.4.2011 02:25, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 27 Apr 2011 13:35:13 +0200, Borislav Petkov said:
> >
> >> If we do this inclusive, then W=2 dumps the, let's call it, level 1
> >> _plus_ the new level 2 warnings, polluting the output with something
> >> I've already seen, but only partially. And then I start to think, did
> >> I see this one already, didn't I, which was it? By the time you enable
> >> W=3, the output becomes pretty useless. For example, W=3 generates 190+
> >> MB logfile here only with level 3 warnings. Now imagine all 3 levels
> >> combined.
> >
> > If each level is averaging 10x the previous level, then all 3 levels will only be 11%
> > bigger, or 211MB.
> >
> > You *really* want to get *all* the warnings - quite often, you'll be looking
> > at a set of 15 or 20 level-3 warnings.  And if you had the Level-2's in there as
> > well, you'd immediately realize that the single level-2 was the real root-cause
> > of all the cascating warnings.
>
> How about W=12 for level 1 and 2 warnings and W=123 for all levels?

I'd be OK with that, or a 'W=all', or whatever, as long as it's doable.


--==_Exmh_1304013549_56837P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNuartcC3lWbTT17ARAlYeAKDPMjG9Gc26WcKVf5SWnzx7GgtxXACdFjRl
EXHG+YxYHLj9GPYMjsaSRkg=
=7cqZ
-----END PGP SIGNATURE-----

--==_Exmh_1304013549_56837P--

