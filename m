Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1JYIlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:41:15 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46739 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1JYIlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:41:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.8
In-Reply-To: Your message of "Tue, 25 Oct 2011 09:02:40 +0200."
             <20111025070240.GB9415@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20111025051928.GA7997@kroah.com> <4EA64BDC.8050709@xenotime.net>
            <20111025070240.GB9415@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319532063_3131P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 04:41:03 -0400
Message-ID: <14295.1319532063@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4EA67623.0047,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1319532063_3131P
Content-Type: text/plain; charset=us-ascii

On Tue, 25 Oct 2011 09:02:40 +0200, Greg KH said:
> On Mon, Oct 24, 2011 at 10:40:44PM -0700, Randy Dunlap wrote:
> > On 10/24/11 22:19, Greg KH wrote:
> > > All users of the 3.0 kernel series must upgrade.
> > I noticed that "must" word in 3.0.7 also.  Please explain.
> Nothing new, I've been saying that for years.

I think Randy means that out of the 29 commits for .7->.8, there's only one
(Hugh Dicken's mremap fix) and *maybe* Peter Zijlstra's cputimer fix, which
even *possibly* rise to the "all users" level, as everything else is against
XFS or CIFS or ARM or something else that's not an across-the-board issue.

And the changelog for the mremap commit says that "but this lucky report
hints", which sort of implies it's a very hard-to-hit bug that nobody even knew
was there.

So it's not obvious from just the shortlog that it's a "MUST upgrade"  category.

--==_Exmh_1319532063_3131P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOpnYfcC3lWbTT17ARAr/RAKCPcRJ2tfQ5ene19/J6yR7oRhctnQCgnHH9
2BNa9LS8gMg+bi8EJUiytkA=
=Nh04
-----END PGP SIGNATURE-----

--==_Exmh_1319532063_3131P--

