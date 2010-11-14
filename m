Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0KNFOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:14:16 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36417 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0KNFON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FgRwKe2SfGxk1on8Th8zysZwGTKMGI3aWky6a8EvFZ5owyx7BGVT/ak4vogsZUNj4r
         udmCiw3zdLuk+ozzvYqpyTLbTfmXWfHgAcihmLFKEI+YZ6NDt+YXb4dB2VEiyFj0NHxs
         po/qT6j62NO5P2saJNJzTNOigXi0F0ZXXHKsI=
Date: Sun, 14 Nov 2010 00:14:07 -0500
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101114051406.GA2050@roll>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com> <1287788622-25860-1-git-send-email-venki@google.com> <1288001573.15336.52.camel@twins> <1288097074.15336.211.camel@twins> <1288101958.15336.284.camel@twins> <1288381343.1988.12.camel@laptop> <20101109185516.GQ8332@bombadil.infradead.org> <1289329348.2191.69.camel@laptop> <20101110034507.GV8332@bombadil.infradead.org> <1289390424.2191.98.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1289390424.2191.98.camel@laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 10, 2010 at 01:00:24PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-09 at 22:45 -0500, Kyle McMartin wrote:
> > On Tue, Nov 09, 2010 at 08:02:28PM +0100, Peter Zijlstra wrote:
> > > Right, I tested it myself yesterday and got similar results. Does the
> > > 'simple' patch from a few posts back work for people?
> > >
> >=20
> > Apparently it doesn't make a large amount of difference. :/
>=20
> Crud, ok, back to basics it is.. thanks for testing!

Much like the other tester, this doesn't make any difference at all for me,
load fluctuates semi randomly as it did before with an average after 20 mins
of around 0.8 with the machine idle. I have to wonder, is there currently a
reason NOT to revert this commit? Does this commit that's causing problems
for myself and other people actually fix problems for some people that
existed before? I just want to know why there seems to be a struggle to fix
the current implementation rather than backing out the change that caused
the problem I'm dealing with and then trying to work from there.

If you've forgotten, I'm talking specifically about this commit:

[74f5187ac873042f502227701ed1727e7c5fbfa9] sched: Cure load average vs NO_H=
Z woes

We've gone through two kernel releases with this commit, and I think I'm
understandably curious why it's not been reverted if it's causing problems
with no solution in sight.

Note that I'm currently running 2.6.35.8 with CONFIG_NO_HZ unset with no
problems with the load average, so at least that works properly, and proves
that I'm not being affected by some other quirk at least...

Machine's only been up ten minutes or so, but here's the uptime data anyway
for the curious:

00:10:02 up 12 min,  4 users,  load average: 0.00, 0.11, 0.14

Tim McGrath

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTN9wHpEncCrqzVruAQKlqAf+KzXtWCLKKuoDFm19V/ZXylExc44Gny8A
hpZ4vHjIss+fbWkv97XdiYrxRbsGCPfUC9ngWJzcymNn93Z9bhDP1O8ROgFze3Lb
1TQ2B1xiasPh2Bq+0jtkQSyjlp60wyTFsb/eWwSq+qlcs1Jfo4Uzhb3FuvVPR/BT
tevi3oxF1CSVKHXAZ8Dn+kmSJDV62/3cYlFHizaKiD5WoTqcyrzs/aspVEcoWJYw
OkFxNKY2T7scHKJqXcno04Jcave7V9+TwxsZX8w8qWWwH1d7mCmeg4SAPv69yBOg
lAS/Iyf5btR+0j8pKA7oqTZTf+Yh/wIiihHAGI24MMQlRPsgVG8Ykw==
=Lqe7
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
