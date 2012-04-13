Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab2DMIx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:53:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43105 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932720Ab2DMIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:53:19 -0400
Date: Fri, 13 Apr 2012 09:53:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH][GIT PULL][v3.4] tracing: Fix build breakage without
 CONFIG_PERF_EVENTS (again)
Message-ID: <20120413085315.GC3168@opensource.wolfsonmicro.com>
References: <1334262300.23924.348.camel@gandalf.stny.rr.com>
 <1334263193.23924.353.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <1334263193.23924.353.camel@gandalf.stny.rr.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 04:39:53PM -0400, Steven Rostedt wrote:

> Looking at this patch in more depth, it may be cleaner to do:

> #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_FUNCTION_TRACER)
> int perf_ftrace_event_register(struct ftrace_event_call *call,
>   			       enum trace_reg type, void *data);
> #else
> # define perf_ftrace_event_register NULL
> #endif

> Mark, would you like to make the above update?

I've sent a revised version of the patch out.  I really don't care which
version gets merged or who writes the patch so long as we can get this
fixed.

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPh+lvAAoJEBus8iNuMP3dj+QP/2tA+4HorXQ1C2h/W3GPlgoU
VlQtVfHmMEf2D6GS/5yrOJa6L7Dn03qbcFn011AXSoPGQOohqEVTiSPmCSD5V2uz
1N16SCHkpxMkpO5OhvM4g7JTlK5jdLbgUYnuafU/vaxONSX2N/Xt0rBcmjcBs4LN
e5tum+tazKWOjwp+tuFlJ2csscK+QDqTweJbkfmoUIMsKtsh/Xa5NoOQApWZLVTz
/LKlhow8Sfb5lTTz66XRxCygvoRo2fW5dVT86USU7VCsHI7g5cP4SH9bJNzSZJqh
JhN1vTt3FLsc3h4U1V5FD/VhoVb5XUvgL40uXwYWtWgFJbi0L4lbUrV3Quz6h/bN
hOPRMQiHdN/ELNB9HqFsuKcz4roZLvAVgl8L+3y2lutWwH1M4n9SwXYsCRMb0rTS
aXPbDYnJcQ7qz9qwdypX7a+5MH7FgeDOEF7LXRuBuYVZmGyGWGYLOoQI/aKbAc3w
kg/JhmikSTiESqcv5UkGNOCckXq/GPuLuW+5d6BSZBBWN6up6KlVyUjHrt/K3zAC
SYMUIhXMdUlrXRMqvEGJ54AZDCJA6vOSQsOSGEnhrejzJ0D781hDqaRZBibv/1U7
JZmrLZh0o85OchTztR6Tc9pIjT0qnId+2U7+GWP4qrVn1rZhEafhzyCvi6UbCODs
wg2XBnEv0n3TEUAqJxQm
=VBHM
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
