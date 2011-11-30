Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1K3Iu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:50:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45307 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1K3IuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:50:23 -0500
Subject: Re: [PATCH v2] Integrated Flash Controller support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Scott Wood <scottwood@freescale.com>,
        Li Yang-R58472 <r58472@freescale.com>,
        "b35362@freescale.com>" <b35362@freescale.com>,
        "linux-kernel@vger.kernel.org Kernel" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 30 Nov 2011 10:51:12 +0200
In-Reply-To: <EFF451D9-552A-4820-90D3-BF3156D5B25F@kernel.crashing.org>
References: <1320053901-23801-1-git-send-email-b35362@freescale.com>
	  <CCF7C6DB-437C-4140-894F-2F497AD610DC@kernel.crashing.org>
	  <8EDB3DC6-63E5-4D5C-BB52-15F32B85C5DD@kernel.crashing.org>
	 <1322602860.2150.10.camel@koala> <4ED5531C.6030104@freescale.com>
	 <EFF451D9-552A-4820-90D3-BF3156D5B25F@kernel.crashing.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eQxlD8JR71lTLUzhZfoM"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1322643080.24797.413.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eQxlD8JR71lTLUzhZfoM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-11-29 at 19:47 -0600, Kumar Gala wrote:
> As Scott said, I was more asking about the 2nd patch in the sequence
> which did touch MTD.  Since that one is dependent on this patch,
> wondering how we wanted to handle them.

I do not have time to review it, but it looks OK, so I'd suggest to
merge it vie the same tree as the rest of the patches.

--=20
Best Regards,
Artem Bityutskiy

--=-eQxlD8JR71lTLUzhZfoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO1e6AAAoJECmIfjd9wqK0T9UP/1/sgKycVkmQu3OzgZZ8JNSm
f9A0fgVSgmRvls7L6k7QWE/KPelAchdiWsSZK3V9MS46mAZmVlGlzvb/xIaUwKNe
qMdZRFFhUEXzYXNLZCbjh3RJBO+nBXdknV8AHJRD515amwyXNipEH+360JpCIlIz
LVneZHn8JX6laFJ4+PJSN1inEhwBs1E45WZf7zlLm+6ir1Csbh1hgQVc/4ql33rz
RHDNHYK265Ub7SYplCLYgziy7h910aXvha5R21v+bYBEMbibxXglYpxyZ2ZenSUA
ZfTHfv6P46Her7lOf07dtZCpshJo1+1CCiOm+lQChrfC9gAm7WJOD9xBxfBN9N8F
7d93EyOmBlYtMQti2XkE49H+BG73xmiLp9B7yRZLOZ0qHAIqUj1lSXOWh5eXmw8Q
KkcRl5SlblnUNeq8r3ChoHD91rNDcmbN2W6fulbANVVtPS2BjDwDnbRyhQxMeoYL
soLjzEttyd3Mta+uZrCFgi7MjlA4+rtdSbiDmoHH3zwja7bFfeebU9tvdZrSurTX
o9QGPvkl6mdtrEuljXJazn2on+4Lk31ao44lsZhRwntousVGjRLh2L8qA9yr0vnd
rSq11tNN5nqWJoIVVO5d2ylt1EJIRtjEGVI1bqGg9FJSsb97t3pvy1l5XAjqN6cX
bchp4eqlZ2UIQJ4XgVTm
=DhO1
-----END PGP SIGNATURE-----

--=-eQxlD8JR71lTLUzhZfoM--

