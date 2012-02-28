Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2B1LKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:10:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56776 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757049Ab2B1LK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:10:28 -0500
Date: Tue, 28 Feb 2012 11:10:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Message-ID: <20120228111026.GC3683@opensource.wolfsonmicro.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 11:02:46AM +0000, Mark Brown wrote:

> Ensure that we always have a definition of perf_trace_event_register()
> by making the definition unconditional.

Oops, sent too soon - the code still fails to link as the ifdefs are
more complex than I'd realised.

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTLX8AAoJEBus8iNuMP3dy7sP/RAZpcuCOEHuMog8S2cKDNP4
M0RKN7fj/zvxEL1p1P/7n7wSSI4KE+fkKJRePpZSWcF1BZpnejMdUUFktX+Qijgc
JE/SYJobxLDofHnu5DHYYcqRVO8erMeULbL977ejQX6OM4OrCUuTAUxg/noYBfYr
X2NJCJA/jX+F3QKuhEL5nFLngi88WsDtfwriRO7aKDbbbWIBWSlfgl2JhKj93TC+
SxZUL6+iMqzq3mgA//3olpK2IIAq1vS1GO6VJwYJ99qXRIoF2RvaofdDwRBf1ovP
fpy+6ZFZLbmZIkk2s4rCgMDolJ8ZDEhn8B1OjjVV4vEOoKofkTJ2mFEv1/7EwyX6
k8zqGmeShor8V7tTUdsiEGpng34cEz6QiUizwXp4NtlYXBwrXpfF4mCh4jucQTWB
1UbyB0TaijYbWxMlNbvgE4VjNilomtFFn57ygguapsNsj6eAi+jZMH/BZas4QVK2
JKUCkmkp+HHXhslqF3Z4Kll+FbW6jZcnxhJKxkPnFpqOmYiD5udCgQlBo2BPCA/w
MzKoji7ompQzGg/xFdsfs4Vab8ayVIO94DlmAdTU5HHNex8RHMiKU7rP7ZLd9IQT
CTPy8YdOfGztQXU+a2aRhXD5l6biOc2hLD4QjS2pN60xia5QTy/+kH4jfflBpyIt
zREEzM38t8DTj34QCsi/
=aY44
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
