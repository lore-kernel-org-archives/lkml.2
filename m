Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0JUI5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:57:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60399 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0JUI5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hvgass0QoCQWYLrV0T4jnae+KjRGCWLNoieKbnoWRT1t3QHk6bj+xeGXTQLfLWEDU2
         JnyHB3aJi4LbbPEH8RXPa/1h+PDsxy/uzGqy/7B5RymlVuAvujuGz7cHQ6KSd7EHUFOr
         TOTd9VeKfAe89X83RoRz5aCiVj7L7ad0elD0c=
Date: Thu, 21 Oct 2010 04:57:48 -0400
From: tmhikaru@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101021085748.GA26125@roll>
References: <20100929070153.GA2200@brouette> <20101014145813.GA2185@brouette> <20101020132732.GA30024@brouette> <1287581440.3488.16.camel@twins> <1287582208.3488.20.camel@twins> <1287584073.3488.22.camel@twins> <1287595605.3488.52.camel@twins> <20101021014843.GA21295@roll> <20101021015337.GA21384@roll> <20101021082233.GD8775@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20101021082233.GD8775@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2010 at 10:22:33AM +0200, Ingo Molnar wrote:
>=20
> * tmhikaru@gmail.com <tmhikaru@gmail.com> wrote:
>=20
> > On Wed, Oct 20, 2010 at 09:48:43PM -0400, tm@ wrote:
> > > On Wed, Oct 20, 2010 at 07:26:45PM +0200, Peter Zijlstra wrote:
> > > >=20
> > > >=20
> > > > OK, how does this work for people? I find my idle load is still a t=
ad
> > > > high, but maybe I'm not patient enough.
> > >=20
> > > I haven't had a chance to keep up with the topic, and I apologize. I'=
ll be
> > > testing this as soon as I can finish compiling it. Thank you all for =
not
> > > letting this go unfixed.
> > >=20
> > > Tim McGrath
> >=20
> > Uhh, problem. This patch does not apply to git checkout
> > 74f5187ac873042f502227701ed1727e7c5fbfa9
> >=20
> > which is the version of the kernel that first exhibits this flaw.
> >=20
> > which version of the kernel does this patch apply cleanly to?
>=20
> Try -tip (which includes the scheduler development tree as well):
>=20
>    http://people.redhat.com/mingo/tip.git/README
>=20
> Thanks,
>=20
> 	Ingo

Tried that, patch still doesn't apply... and I just figured out why. Looks
like my email client is screwing the patch up. mutt apparently wants to chew
on my mail before I get it. viewing the mail as an attachment and saving it
works properly however.

Now that I have properly saved the mail, it applies cleanly to tip/master as
well as 74f5187ac873042f502227701ed1727e7c5fbfa9 - though in the latter's
case it's having to fuzz around a bit. I'll try testing
74f5187ac873042f502227701ed1727e7c5fbfa9 first since it's the one I *know*
is flawed, and I want to reduce the amount of changes that I have to test
for.

I'll build and test it, then let you guys know if there's any noticable
difference.

Tim McGrath

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTMAAjJEncCrqzVruAQI2nQf/VVfsakXkgdZNbGhzki2Xiit2FTDW3+I9
PI/1NyJ9lGX1GMn8GtAyCwYnTDn36bRepo1CVx1BSx/tqhLdhzm/OyS6jlW260O6
aG3iAZQ2kqLyuNNFq/gI3YuFXorrpaYA595NwhWKkyhUapzeKvqSmrz10zQM56SI
I05PCD115+44N9iOYR0ZpUDy+67/MtFdFwHzYNUk8hjg6S1+YBL7SI0wle7Tv3j9
g0IGT8ddIZmBy4/pqyYzwq8OMp58I1YHvR2d9mjwhK8skZ2PvYZdMbDg4EBL3CnT
WB6nv30UhZCfoYzV0AL84rlqsT5jsxcNAVEsy23tAyKwp+sXEJ8FYw==
=UdhS
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
