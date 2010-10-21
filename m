Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0JUBxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:53:43 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38866 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab0JUBxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C6NwEWHeZzRfm4qlr1BuBr5nZnVMsmHivURFib5qLtGZgTYaEyyWKxs15cS+TE6sd1
         emSVxdQZvbu1barYQoZbp99vJAB5a888pU66xZxDncpQPI0e3f4nbOjYID0Qsld4SEv7
         vDcBHEms3WIy245AgELYA027dHu9CshFFhBrc=
Date: Wed, 20 Oct 2010 21:53:37 -0400
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>, Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101021015337.GA21384@roll>
References: <20100929070153.GA2200@brouette> <20101014145813.GA2185@brouette> <20101020132732.GA30024@brouette> <1287581440.3488.16.camel@twins> <1287582208.3488.20.camel@twins> <1287584073.3488.22.camel@twins> <1287595605.3488.52.camel@twins> <20101021014843.GA21295@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20101021014843.GA21295@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2010 at 09:48:43PM -0400, tm@ wrote:
> On Wed, Oct 20, 2010 at 07:26:45PM +0200, Peter Zijlstra wrote:
> >=20
> >=20
> > OK, how does this work for people? I find my idle load is still a tad
> > high, but maybe I'm not patient enough.
>=20
> I haven't had a chance to keep up with the topic, and I apologize. I'll be
> testing this as soon as I can finish compiling it. Thank you all for not
> letting this go unfixed.
>=20
> Tim McGrath

Uhh, problem. This patch does not apply to git checkout
74f5187ac873042f502227701ed1727e7c5fbfa9

which is the version of the kernel that first exhibits this flaw.

which version of the kernel does this patch apply cleanly to?

Tim McGrath

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTL+dIZEncCrqzVruAQJgaQf/T0+A0anYe5x4V7SJ8qrQBc6zliOrqjp6
LOp6wGipVULCZDF5a75+w/9g0SDdglCFw7lHdLSpGbUPakLMLE9lNhk6lLkzgyc+
ZBSrz++5VAhbM11C1ZURpP4GR7m3NRO1Cxm51OfUUIigwYu06rBjcgizOZQvW7S/
iSCg7OhespAEMOAyCxqyF8fiRjL6LSN2WUonwmEBwQpjPxxDGvcL79osyvWuawU0
LHrehdQKjUTvVzWylR8RLp8vlY7jUgBIxCFBke4lvOCQ1Q9D7p8HFKXeZ8iiMymt
H9T+jRNhmTGx26b/klZ0qLd98HGYtwGbdghj06cRPtgL7dnY5rQVbw==
=mbbR
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
