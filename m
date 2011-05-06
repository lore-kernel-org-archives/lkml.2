Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1EFAEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:04:50 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34983 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1EFAEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:04:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reboot: disable usermodehelper to prevent fs access
In-Reply-To: Your message of "Thu, 05 May 2011 14:34:58 PDT."
             <20110505213458.GA4331@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <1304595126.1284.3.camel@zag> <39558.1304630665@localhost>
            <20110505213458.GA4331@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304640285_5038P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 May 2011 20:04:46 -0400
Message-ID: <45795.1304640286@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DC33B1F.005B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304640285_5038P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 May 2011 14:34:58 PDT, Greg KH said:
> On Thu, May 05, 2011 at 05:24:25PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 05 May 2011 13:32:05 +0200, Kay Sievers said:
> > > In case CONFIG_UEVENT_HELPER_PATH is not set to "", which it
> > > should be on every system
> >
> > If it indeed should be that on every system, shouldn't it be listed
> > in feature-removal-schedule.txt?
>
> It's the default value, but distros, and people, can and do override it
> for various reasons.  Why would it be added to
> feature-removal-schedule.txt?

Well, what Kay said was "it should be on *every* system", making it sound like
it's an option past its shelf life.  Certainly, "the default should be null for
the vast majority of systems" is a different scenario.

> > Does anybody have a running list of "Stuff we set by default at one time, but
> > no longer recommend"?

> Look at the default values for different configurations options and why
> they differ in your system is about the only way that I know of, sorry.

Hmm.. I suspect diffconfig will only get me part of the way there.  Maybe what
I *need* to do is find a 2.6.25-ish x86_64 defconfig, the current one, diff those, and
then see what changed (as opposed to truly new config flags), and then see
how many of those changes do/don't show up in *my* config as well..

Maybe that would be a good project for some #kernelnewbie to look at ;)
"In my copious free time" ;)


--==_Exmh_1304640285_5038P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwzsdcC3lWbTT17ARAjp3AKDNRjxUA8mqCDC6FH9Pm1Ar5bcCTgCg3i6O
OQWDEsTYc8Vuqpqw79vyAXg=
=zLyW
-----END PGP SIGNATURE-----

--==_Exmh_1304640285_5038P--

