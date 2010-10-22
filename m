Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0JVBhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:37:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42482 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab0JVBhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wQH5t6CQmDuCDlgjRMTTPDfl4tF2vzeuFISr65x/ZDONXYxcPyQ63YD+dzheq2uEDi
         KQVcvBsLKSi+uyvp//CAwlEmuAB8pS2WR6OFepnmNbp1lgRASOP4IEWNv972qNnqUjaz
         3uq48xmpYhl66cjWd/qigKHTMhiQ2mwMTJxeg=
Date: Thu, 21 Oct 2010 21:37:32 -0400
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>, Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101022013732.GA6652@roll>
References: <20100929070153.GA2200@brouette> <20101014145813.GA2185@brouette> <20101020132732.GA30024@brouette> <1287581440.3488.16.camel@twins> <1287582208.3488.20.camel@twins> <1287584073.3488.22.camel@twins> <1287595605.3488.52.camel@twins> <20101021014843.GA21295@roll> <20101021183621.GA2244@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20101021183621.GA2244@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2010 at 02:36:21PM -0400, tm@ wrote:
> On Wed, Oct 20, 2010 at 09:48:43PM -0400, tm@ wrote:
> > On Wed, Oct 20, 2010 at 07:26:45PM +0200, Peter Zijlstra wrote:
> > >=20
> > >=20
> > > OK, how does this work for people? I find my idle load is still a tad
> > > high, but maybe I'm not patient enough.
> >=20
> > I haven't had a chance to keep up with the topic, and I apologize. I'll=
 be
> > testing this as soon as I can finish compiling it. Thank you all for not
> > letting this go unfixed.
> >=20
> > Tim McGrath
>=20
> Now that I've actually had a chance to boot the kernel with the patch
> applied I'm sorry to say but the load average isn't decaying as fast as it
> ought to, at the very least. My machine's been idle for the last ten minu=
tes
> but the one minute average is still at 0.89 and shooting up to 1.5, the 5
> min average is 0.9, and the 15 min average is .68 and climbing. Even as I=
'm
> writing this the averages are continuing to drop, but *very* slowly.
> Glacially, almost. The one minute average is continuing to randomly spike
> high for no reason I can tell as well.
>=20
> I'll let you guys know if this actually bottoms out at some point.
>=20
> Tim McGrath


	It did not. When I came home and checked, my load average was a
steady 0.7-0.8 across the board on all averages with the machine idle since
six hours ago. I guess the patch didn't fix the problem for me. If you want,
I'll try building master/tip with the patch applied, but I doubt it'll
really be different.

	On the plus side, the patch did do something - it seems much less
erratic than it used to be for whatever reason, and now just has a very
steady load average rather than jumping about as it does without the patch
applied.

	I wish I understood the code enough to know what is going wrong
here. I have to wonder what impact the original bug was causing. It seems to
me that if it only affected a few people it might be worth backing out the
patch and rethinking the problem it was meant to fix. On the other hand, if
there's some way of diagnosing the problem I'm all for it - is there some
kprintfs or something I could put in the code to find out when it's doing
unlikely or 'impossible' things? There is serious weirdness going on here
and I'd like to figure out the cause of it. I get the impression we're all
bumbling about in the dark poking at a gigantic elephant and getting the
wrong impressions.

	Tim McGrath

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTMDq3JEncCrqzVruAQIYoAf/YafY4vG2vszmP6Zan8a8vQVSIp8C4wp2
4648znjze6W7n/R7lh5tMUCAIjI3P0gbMrlQJAKUQcbgdw6BtMER0V482U29S+Te
AgqBuqWtm3AbfYCGpSPQzenFBEizjdHKfVG+jcz02OqNh4igducZUhWBi66cm6BG
JMtJD5zH654LYsqGQzRYcRTja8TY5LrU80uahbOoLJm0fSsEn40B6Decgvkv7r+U
qOOyzoAeF2y6Dn/A94SpBsaP8MCJiu0zhw3avYspXtI3/XdHXPnV+bpkpCrpCvhI
Ukyh4HLDeKv7i8FvbxrRSv+4j7mBF1Z2KvnHsv+pWH9+BHvpFIhuuQ==
=CiM/
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
