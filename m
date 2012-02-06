Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2BFMgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:36:05 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28632 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2BFMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:36:03 -0500
Date: Mon, 6 Feb 2012 15:36:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] checkpatch: Add line-length options, set default to 100
Message-ID: <20120206123642.GA3674@mwanda>
References: <20120204130330.GA30198@elte.hu>
 <1328372536.5766.3.camel@joe2Laptop>
 <20120204180237.GA7682@elte.hu>
 <1328381300.5996.2.camel@joe2Laptop>
 <CAOJsxLGtkVDZpFn3WY21Z4nqnH159KLyo7sx5rhe73bz712sYw@mail.gmail.com>
 <1328383659.7008.7.camel@joe2Laptop>
 <20120205113821.GA22399@elte.hu>
 <1328458885.7008.58.camel@joe2Laptop>
 <20120205181349.GA24281@elte.hu>
 <1328468489.7008.70.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1328468489.7008.70.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F2FC904.007F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

It doesn't make sense for everyone to pick a different standard.

I do hate the check, but if it were disabled by default when people
used the -f option, that would make me happy.  The -f option is
mostly used by newbies trying to write a My First Kernel Patch.

regards,
dan carpenter


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPL8laAAoJEOnZkXI/YHqR6fQP/jnV3HAlBduLsHpRhEDVHFMW
9mO0eEDaFd4m3+1WLR044vkvRM5ynURNsXrjZOZ/lC80TgkAjYxiBdLHm30eQw+6
5J+IDYcXJOTP/voeiuM8T6/8f1keL+k6IrLH3nurtwioBJAYetA9Sg9RcjdLrTPx
JlL1zzHtMgYJC7Ff34MJUkAzeoQlPu/SaWLlNG+I7BST0MIqKJuF3TTIOGwHbMe1
PPExCD949qTM7Nq8DMM4EQnDPp1ML7rZlaIZB5gTm17yGJLXsICauRbTfs1cs8sp
jZcch14Q856hCpms19vpaE7fyqfpQJfswrPjl7r3knMb0O/DyG8JOlJloz6E3noT
pb5962t57qWNqWGwu+HqDPvG3k8gHoHckV+obtvfM00HmCw6galdfCX467dKkIeC
NUJ4UmJxVGV/GDCl5lXmJ6l2EgrsHCqQYa90DLGVkRlvgtKa4we8T6QUwCwFgj7T
9DWQQ9JPunzRnyK5K1bh73zRCc8wDrak778BZFEZn9Tw9lEFxEMwOx7xw/OG3VNd
3JwLIUXIXpaSVyy18w3QckIs4XS5BxnItHrex1RnfCC8BDjs8/cl1VOFFbd6DZ1+
f2QJdzX3u/BiTnHUD3SIc96g+bmzpI+aB+Blueb/LiRZK+8xhYoooVtUZqI+M9NZ
mwaRSmcD3bgB9TGO4qCV
=6TIU
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
