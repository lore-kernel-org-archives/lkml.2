Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2B1ODj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:03:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36556 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab2B1ODi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:03:38 -0500
Date: Tue, 28 Feb 2012 14:03:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Message-ID: <20120228140335.GM3683@opensource.wolfsonmicro.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120228132159.GA1694@m.brq.redhat.com>
 <20120228133712.GL3683@opensource.wolfsonmicro.com>
 <1330437729.25686.211.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pjk796cY0SfIo9Z2"
Content-Disposition: inline
In-Reply-To: <1330437729.25686.211.camel@gandalf.stny.rr.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pjk796cY0SfIo9Z2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 09:02:09AM -0500, Steven Rostedt wrote:
> On Tue, 2012-02-28 at 13:37 +0000, Mark Brown wrote:

> > ARM.  If it was not possible to switch off PERF_EVENTS it shouldn't be a
> > config option in the code as this is just creating complexity and
> > potential breakage.

> It is possible to switch off PERF_EVENTS, just not on x86 :-/

Well, if you insist on using these restricted architectures :P

--Pjk796cY0SfIo9Z2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTN6lAAoJEBus8iNuMP3dPY8P/1h9z5rlbK+0wy2VbBHiNIFW
lRxN5al+YpiyjmRcH5yLk2nz13l3XlTTZJH1veMtPJ2r/BtkgyQHThsbHloKCAea
yAVT2YaJQN94SCsLOwVSoxl8Bcto+14bYPmW/nZQSVbkhc9K4stcVEdHDKKiD4jg
7syy6wvII+GBQ+a9JH8yxyuPV26OjQFhPIAFejhmJUpcxQ3fHw4SNWmwY2hd7ARr
bf0j50AOlhuwLs0Am6E4KDCTHxgGbIp77dT3CO7cfk1aAZhjHC7HGypEokxBV7hC
459CtAEHsPHPllOo7E6D4tuZpNpo0Uli8Laa6sNQf6bWV+iy3r9xP3OkkW7MSWNp
bTMZc6ZHmTr6xxcobpMPu7BWI5ZSYWHsWgFubDYLv8GmabKABgcisua/1hsy69np
oVd1Wyux3TKuoFETckzy9Ju0XAIsX5IcAzhP3X/3pSbzPvViKcKXjJKzRCKb/3Yg
Qfl8ELfVFEkqtrD/mj3XUtjtul81T9BOKSyFEGBoSTmV+Ci7E8onIaiVHeDOpgjk
aOZF2UMj1PINqtoNELwEMeHdrE+e/aPdTRXvG1fr7qXR/zsa/6pc+BkttZD++2fg
SchlYkLLH5PBPmyrPhfb/BY2RI9ApyHTsMqqzqhVB9DbahQdhX2F5M9m3EtJ0S2u
VUGhaYbsPgT4C6aiKWR5
=IwuC
-----END PGP SIGNATURE-----

--Pjk796cY0SfIo9Z2--
