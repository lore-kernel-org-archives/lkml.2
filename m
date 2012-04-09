Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2DIRL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:11:27 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:40652 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751672Ab2DIRLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:11:25 -0400
Date: Mon, 9 Apr 2012 10:11:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120409101119.47e770b2@jbarnes-desktop>
In-Reply-To: <1333104359_155028@CP5-2952>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FsdMHIUUW=fBIKLM0qtRQPz"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FsdMHIUUW=fBIKLM0qtRQPz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Mar 2012 11:45:43 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
> > I don't know what to dump more, because iir is obviously zero too. What
> > other sources of interrupts are on the (G33) chip?
>=20
> IIR is the master interrupt, with chained secondary interrupt statuses.
> If IIR is 0, the interrupt wasn't raised by the GPU.

I've actually seen cases where one of the PIPE*STAT regs is stuck, and
even if IIR is 0 we still get interrupts... Jiri can you verify the
PIPE*STAT regs have bits set, maybe one or more we don't check for?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/FsdMHIUUW=fBIKLM0qtRQPz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPgxg3AAoJEIEoDkX4Qk9hytYP/1Ky9cq25TYIbChaX1t9yyLm
FiMrTw/HmuYMhb4/aGceOeglA4gCrD2Yr8QKJgXtcXi5BSS/F8ZUx+E5C7bRj6Oc
I3oEV79gNgIFHvs4JqgbrYFW/peX27L30GjUiiIiL2Yx0YgsBvoZtYhsdXtMcr8M
99Q1SZh+Qt2blohDnle/Npq26gOOxAJ9LeozOSQ1jrL6hrZayYunw5iPPjnfN/Qb
s17LN9QJ33XIcI1vKgtCjFnPjEaZde/UA4MAzKk9D5m5LWbJ1vmfMc51lvbxXqgT
aBgtkY8fMC0BZrHZ0Gay70dR//vqVi2RbEt//PPhI96uGUf8C+pI/StudyJnPLga
5g9OM5B89tyH0pYXzmBNsyvA2Hv6Sdqg7vsj3e2gzg9xGw3ETQbLt6bUHSzU/Ea5
a/wWwTpI2TSWqVdS/zpLziM7xrVZdMjB2f+mB6C0P23nlAqteL2JcNXgWOvLplzO
XX9Nl805rPKkmeeZ8ifsqgY4Z5nZzx91TAZtQqDc+9yR2jUeHfDdqufHBzD1TeOp
5J1sZSAJLx19bzGUwOGwNq9zjKA7U7bDegBw0o8mVK78o0fIgTrpeUnMHO4jQNBy
0V5R2DevvRHEk03rFcXLSmyWpGvgjhUSEQfxsxsoOux70XUblg43veAj396ZMnfA
u8B/z5Q80xsRscPhTs9u
=6dK5
-----END PGP SIGNATURE-----

--Sig_/FsdMHIUUW=fBIKLM0qtRQPz--
