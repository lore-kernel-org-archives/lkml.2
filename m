Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2BKPdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 10:33:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56018 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076Ab2BKPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 10:33:28 -0500
Date: Sat, 11 Feb 2012 15:33:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Todd Poynor <toddpoynor@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Oleg Nesterov <oleg@redhat.com>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linaro-kernel@lists.linaro.org, Mike Chan <mike@android.com>,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
Message-ID: <20120211153324.GC31887@opensource.wolfsonmicro.com>
References: <20120208013959.GA24535@panacea>
 <1328670355.2482.68.camel@laptop>
 <20120208202314.GA28290@redhat.com>
 <1328736834.2903.33.camel@pasglop>
 <20120209075106.GB18387@elte.hu>
 <4F35DD3E.4020406@codeaurora.org>
 <20120211143951.GA24564@sirena.org.uk>
 <1328971983.11320.5.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <1328971983.11320.5.camel@laptop>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 11, 2012 at 03:53:03PM +0100, Peter Zijlstra wrote:
> On Sat, 2012-02-11 at 14:39 +0000, Mark Brown wrote:

> > For step downs this isn't such a big deal as we don't often care if the
> > voltage drops immediately but for step ups it's critical as if the
> > voltage hasn't ramped before the CPU tries to run at the higher
> > frequency the CPU will brown out.=20

> Why isn't all this done by micro-controllers, software writes a desired
> state in some machine register (fast), micro-controller sets about
> making it so in an asynchronous way. If it finds the settings have
> changed by the time it reached its former goal, goto 1.

*Something* is going to have to wait for all the steps to take
place, if when frequency scaling you're not particlarly worried about
waiting for the the actual completion of your frequency change then
doing it in the CPU isn't that hard - you just post the request off
elsewhere and let it get on with trying implement whatever the last
request it saw was (along with all the other constraints it's seeing).
Modulo non-trivial implementation issues, of couse.

> Having to actually wait for this in software is quite ridiculous.

Well, it's also not terribly hard.  There's use cases for having this
stuff offloaded but if you're not doing that stuff then why deal with
the complication of designing the hardware?

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNoo+AAoJEBus8iNuMP3d/moP/1Q4g4uUqE3lVEbCySa4UgdT
WdYgyRB91UPrA6Qy3TEjdvj0mD5t4Fz8CJqtrtWi1e9D8IU0O/zyNIvvHy2HKjhH
o/S7ktq2CxevBJRz5GLt1Ip71E+UUQ8y7sUtdeXSw4kioYN5Hz6ioixKcseoBNzO
2flvz1gLzpsZXaGVr8pJcDDH2iNFcubD1le56pu50BEmwnbxZZC+qVfYJ8cT4e35
2MJvleWw+lhjS9lE81l9jKQwCnlFCSJ/ThxKO/x/CAoerNg9g68C/nFAko20x78o
ZDBxV3Ob+eYRdTep6nOX1BY8AlDxT6+Oge6TA2mxhwnYm/3qw4o0R2D4FPf8RlBs
KI25j4KiF5dYtiQXsKkEfgrNQEBjI38opX5Cmt6+zh3GlbOdCXZEnf4zIGpZIfrI
tBQ8tLw5ALH/nfeOAasR/AydSm8HbH6LiXYwoT1U6X5NwWaOV5qTipsUj2ApcoF6
j3IMCeVdIeHFH48wLYNr16PrWFje+dKvc/yiV9aEZ+BIEWeYIPOTrge2oZldEJlh
3G8NWPXR63latIPB7BlB7Jbncqva03P1gL6p/jLESfwE6GJ3NjxxNZYtL//Zu/Vm
vYcDM49Im7P0NZRe6rr7gX/6hEfKou11NNsGZY2tteivGhijtBX7YBOoBDrXCYm9
8WB74bASjR/+bMBbkwzS
=rfB0
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
