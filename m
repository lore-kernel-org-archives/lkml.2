Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1K3DvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 22:51:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab1K3DvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 22:51:07 -0500
Date: Tue, 29 Nov 2011 21:50:39 -0600
From: Clark Williams <williams@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into
 infinite spin in RT
Message-ID: <20111129215039.344b5109@redhat.com>
In-Reply-To: <1322618120.17003.104.camel@frodo>
References: <1322618120.17003.104.camel@frodo>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GkQ.xRZjKTIuMwDgmCZ./Am"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GkQ.xRZjKTIuMwDgmCZ./Am
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Nov 2011 20:55:20 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
>=20
> I forward ported this code from 2.6.33.9-rt31, but I think you were the
> original author, as I found most of this code in the
> "tasklet-redesign.patch" from my broken out 2.6.24-rt patches. I
> committed it into my git tree (stable-rt) under your name, and added the
> Signed-off-by that you had in that patch, if you have and objections,
> please let me know. This patch should never see mainline, but it will
> probably be going into the -rt branch. I wrote up this change log, if
> there's something you don't like in it, let me know and I'll fix it.
>=20
> Luis and Clark (I love saying that),

No matter how many times you say it, I'm still not treking across the
USA with Luis. :)

>=20
> I booted this patch against 3.0-rt stable, and it didn't crash ;)
> Could you apply it and see if it fixes the hang that you've been seeing.
>=20

Yeah, since Luis is a couple of time zones ahead of us, maybe it'll all
be fixed when we get up in the morning.

Clark

--Sig_/GkQ.xRZjKTIuMwDgmCZ./Am
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk7VqA8ACgkQHyuj/+TTEp1fpgCgmxNaB31+PGjxmXsv5LkZbJhf
JuQAnAt90daKylpX3EWzUn/WRnp4UX7T
=3wM1
-----END PGP SIGNATURE-----

--Sig_/GkQ.xRZjKTIuMwDgmCZ./Am--
