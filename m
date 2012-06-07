Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2FGX6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:58:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53382 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab2FGX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:58:09 -0400
Date: Fri, 8 Jun 2012 09:57:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: boot problem with next-20120607
Message-Id: <20120608095755.2676d319863e46b87b907774@canb.auug.org.au>
In-Reply-To: <20120607150549.63f3ab81.akpm@linux-foundation.org>
References: <20120607135320.7a1298385346bc238a0f92b0@canb.auug.org.au>
	<20120607150549.63f3ab81.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Jun_2012_09_57_55_+1000_N.EOXjLgA/W/ct5x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Jun_2012_09_57_55_+1000_N.EOXjLgA/W/ct5x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 7 Jun 2012 15:05:49 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Thu, 7 Jun 2012 13:53:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >=20
> > My boot of next-20120607 in PowerPC produces lots of these warnings:
> >=20
> > BUG: Bad rss-counter state mm:c000000278508000 idx:0 val:-27
> > BUG: Bad rss-counter state mm:c000000278284000 idx:0 val:-27
> > BUG: Bad rss-counter state mm:c000000279e13000 idx:0 val:-27
> > BUG: Bad rss-counter state mm:c000000278285400 idx:0 val:-27
> >=20
> > And so on (with different mm, idx and val numbers).  Searching showed me
> > commit "mm: correctly synchronize rss-counters at exit/exec" which seems
> > to be there to fix this exact problem?
>=20
> Well that's a worry.  Are you really sure
> mm-correctly-synchronize-rss-counters-at-exit-exec.patch was applied at
> the time?

Yes.  This was exactly next-20120607.

> There's been an extended amount of inconclusive waffling on that patch,
> but I thought it concerned the best way to fix it, rather than
> *whether* it fixes it.

Ah, well, it may fix it for some, but not for me - I have never seen
those messages before yesterday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Jun_2012_09_57_55_+1000_N.EOXjLgA/W/ct5x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP0UADAAoJEECxmPOUX5FEsYAP/3PbIsrSYIg2BeqL0girwvkZ
FEJQA3S9unyVuVXvCj+LhRCApUFELfBjuIuieJNPG8szSM8OGwB6hmaBhBqSup4o
yANvQTdVw8fJieTXWc2JaD9sRZYrQyx6Cia3/CAP+Qd83zNwtl9abQKYuC4Jq87Y
hSzFbw5lAzAxZZup8trxOki96Sy/s71nl8m4+RXhPxiPtgbuCV7qVEwQcCnneUca
c/dL+5fP90F6j62PBJUrce85zjdYIUAFAGn3mpdrOGeLb2/G6v163wQj08x9cyYo
NEmKOaM1iLn3yEbsRoTLRqJHK1k3CjoIZEhcptdq/05Y2Uz9mOfZAhL3jktLrOv8
i9etQq0JC8JYU53m8YSEIK0TaMFZidM3iBOv3Zbt+b0oyJpIrk0vXZYH9eazOez6
RcEKXin9CWBsUc0iOE/N9vgpkBb7CyObbDbJiD8UZ6JE2FMhDiWXPN4JE62xCkV+
eoyY0UrKdeFeIQqP/Y6AMtIz2wz0b3y/mH/6loMv5Z3aSi+gE2N/r0m8G1ex9moI
hM8M8xTPW2vR+SF0uIhORQb/wQmyJF74S9JfoQ3qQVAv+5YoXMiJv7TYmOE2Z8Z5
gcXoQaWlw/Zs+KgO7DQHaoK3qhjsBECqyY/BMpq393G/fYBJNGbhl4AoQwG7wFA+
N5x1qFo1w54+MpRXObPJ
=Skdd
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Jun_2012_09_57_55_+1000_N.EOXjLgA/W/ct5x--
