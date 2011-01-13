Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1AMApC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:45:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45781 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab1AMAo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:44:57 -0500
Date: Thu, 13 Jan 2011 11:44:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: on builds/randconfigs (was: [PATCH -next] thermal: depends on
 NET)
Message-Id: <20110113114446.cba7a01f.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.02.1101121654000.19754@x980>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
	<alpine.LFD.2.02.1101121257580.18873@x980>
	<20110112131800.d64c1a86.akpm@linux-foundation.org>
	<201101122224.54330.rjw@sisk.pl>
	<alpine.LFD.2.02.1101121654000.19754@x980>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Jan_2011_11_44_46_+1100_zmrtz.6A9nI0lFb9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Jan_2011_11_44_46_+1100_zmrtz.6A9nI0lFb9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 12 Jan 2011 16:58:26 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
>
> Kconfig select needs to be fixed so that it is not possible to
> select something if that something's dependencies are not met.

So, should the config step fail if such a thing is attempted, or just not
honour the "select"?

BTW, Linus asked me to investigate the alternative of having "select"
(recursively) automatically set the dependencies if they are not already
set ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Jan_2011_11_44_46_+1100_zmrtz.6A9nI0lFb9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNLkr/AAoJEDMEi1NhKgbstocH/1ekmaRvF96s6Bb6j2kdqjxK
NIRjyXSVORvubLeseJ5pvHRsikHyfYtlJyQrYuikvc5jFlM8T30OyhJ6eSBb1M+A
4xX7a+oTV7jF1xdeD7zNbJJNwStpSO47uwfrQvwjh9xteL9CAy973351FggUa0J7
txLRLhs650WVl0K0ejnWmQNKyVqLVOAToRWAqGBBFKDrVkifeweLFbGBWDkyNmZj
YHQEFaneQ4mg7bVxIAz4JUtEMQ0roKMW2lO/xVUXvRE8gHYs1fnxRiHKoYZRf/yu
+z7+M3lnPlAY54AU+EIx1ThFGT9ZCpSkI+QMIKZ7i6zQxJFaJ+yM/DvGvUERpsQ=
=7cyQ
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Jan_2011_11_44_46_+1100_zmrtz.6A9nI0lFb9--
