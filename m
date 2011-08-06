Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1HFHEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 03:04:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52594 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1HFHEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 03:04:33 -0400
Date: Sat, 6 Aug 2011 17:04:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <rdunlap@xenotime.net>,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: linux-next: Tree for July 25 (xen)
Message-Id: <20110806170418.897cc0513af4189d89e6c03f@canb.auug.org.au>
In-Reply-To: <20110806015815.GA26833@dumpdata.com>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
	<20110725144629.b752bf14.rdunlap@xenotime.net>
	<20110804193534.GB12729@elte.hu>
	<20110804195539.GA11198@dumpdata.com>
	<20110804131516.c4da6595.rdunlap@xenotime.net>
	<20110804223259.GB4370@dumpdata.com>
	<20110804224020.GA21492@dumpdata.com>
	<4E3B3117.5050308@xenotime.net>
	<20110805080531.GA8052@elte.hu>
	<20110805211423.GA9765@elte.hu>
	<20110806015815.GA26833@dumpdata.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__6_Aug_2011_17_04_18_+1000_RF4fIp0aJrL+3PA3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__6_Aug_2011_17_04_18_+1000_RF4fIp0aJrL+3PA3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Fri, 5 Aug 2011 21:58:16 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracle=
.com> wrote:
>
> Much appreciate for the report. I believe this fix (which I think hit
> linux-next yesterday?) should do that:

Yes, it is in next-20110805.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__6_Aug_2011_17_04_18_+1000_RF4fIp0aJrL+3PA3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOPOdyAAoJEDMEi1NhKgbsgDcH/3VkbWFgxXypVcd/sVzDiLRc
YLvF4z73HyGbLLXBBsWgc+yYv3euTYdq07jz7Gb3oVFq4klpuFjt3ILYzAEyOz/x
WfUgg8v+FaPwvum/sxeRMqlYrOINQj4iteDxImWPSGahxZgKBsCFDxUtePY6jAwj
EW/gipFO/OPhZx7mrYOsDj/zeiZhatY486L69GDS9Dl/HmeX8/hP9nPoxvmQ0dhn
+a99a9b2fnnTRt0SnW8p5kt5JyR3HBui8K0KwTqCG1YRA0tfFCJ4EvX0DYuePIep
50ZNrJqpGcgeLO7bXnbgRyioPOmbDKw1Z3cIBGhz5gDxKRxYYyAcF3vos3W8TSw=
=Zu6U
-----END PGP SIGNATURE-----

--Signature=_Sat__6_Aug_2011_17_04_18_+1000_RF4fIp0aJrL+3PA3--
