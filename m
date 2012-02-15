Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab2BOQEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:04:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42898 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935Ab2BOQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:04:44 -0500
Date: Wed, 15 Feb 2012 08:04:38 -0800
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
Message-ID: <20120215160437.GD2996@opensource.wolfsonmicro.com>
References: <20120208013959.GA24535@panacea>
 <1328670355.2482.68.camel@laptop>
 <20120208202314.GA28290@redhat.com>
 <1328736834.2903.33.camel@pasglop>
 <20120209075106.GB18387@elte.hu>
 <4F35DD3E.4020406@codeaurora.org>
 <20120211143951.GA24564@sirena.org.uk>
 <1328971983.11320.5.camel@laptop>
 <20120211153324.GC31887@opensource.wolfsonmicro.com>
 <1329313084.2293.105.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
In-Reply-To: <1329313084.2293.105.camel@twins>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 15, 2012 at 02:38:04PM +0100, Peter Zijlstra wrote:
> On Sat, 2012-02-11 at 15:33 +0000, Mark Brown wrote:

> >  There's use cases for having this
> > stuff offloaded but if you're not doing that stuff then why deal with
> > the complication of designing the hardware?=20

> Because doing it in software is more expensive?

> Penny-wise pound-foolish like thing.. you make the software requirements
> more complex, which results in more bugs (more cost in debugging), more
> runtime (for doing the 'software' thing), less power savings.

> Esp since all this uC/system-controller stuff is already available and
> validated.

It's really not - like I say most of the times people have tried to
deploy this on embedded systems it's just made everyone more miserable
and typically winds up getting turned off or bypassed.  The PMICs are
much more decoupled from the CPUs and the power control on the SoCs is
more fine grained than you seem to see in the desktop market.  There's
software effort but people are willing to spend that for microamps and
all other things being equal they'd typically rather spend it in the
software stack they're already working with rather than in a separate
stack for a microcontroller.

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPO9eOAAoJEBus8iNuMP3dIFQP/j6N0/AYlrCYqKT0Uujt6S26
ifZdkc4w8Egox3etMb9nNXhcqohs5og/APuE61ITvflVd0WwRTgDxjx5lFA+5W94
KFJ6t1G+bByC28NfgnRKU0iMZT/uXH4rKWE7pRuxpCnjOetCY6UHqdDQZ+HAe3kP
r45tcE7j7OVSP9uHWLAJHiQ4DhfDoWUMNuxGfEOGNhH6qzzM0PuX+cNsrymGTGlc
1hKYP8bfkZzkjh6/HDzKWp+uoB+BMQsrK/YpS98Hor7MRBLoZyduI+DAwg/j6Yug
E588ChgrEZTSfMER2NUluPv8i+DhEyzYcGlkTOlh4EnNNS+s0e6M7YexkUestMgZ
ac0yuJdmFIUdhuAfGtlw7mc6esIZ1lfEcp8uzmhg7MxoFheoZ0YZd8/l9/O+T199
/NMVXctkRiWPACelBTWhng6DN7Ve4CCReuqL4ZFmMWHE1sZI0ShdGjo6j4mf7Yht
XKBETcIKdKbA6NXc9aByMBfPgL3m2O4EOM3mEdoouqiRRwTZBYJYxZ4+JXSxM1d8
Xw+1hrdZDORhJWKsy7j/erwMYN0TC6VscifGa3Mf576eTmKyTMoMXL+8O50RkbRS
iAaHhLEV9wHnk10BVdp1vR0d/cPgyNKfyAmlabVvMHdgbMii5cnTju8/w5MQVpY0
MOMtlgCP0277Eltx4d6j
=qMnv
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
