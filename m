Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab1KBBNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:13:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44385 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1KBBNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:13:23 -0400
Date: Wed, 2 Nov 2011 12:13:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, miche@google.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: Regression: patch
 " hvc_console: display printk messages on console." causing infinite loop
 with 3.2-rc0 + Xen.
Message-Id: <20111102121309.4dbb0d2ac90d2879130820dd@canb.auug.org.au>
In-Reply-To: <20111027054806.GA1377@suse.de>
References: <20111027053007.GA32765@phenom.dumpdata.com>
	<20111027054806.GA1377@suse.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Nov_2011_12_13_09_+1100_lsOPgMWQm04RXl/E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Nov_2011_12_13_09_+1100_lsOPgMWQm04RXl/E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 27 Oct 2011 07:48:06 +0200 Greg KH <gregkh@suse.de> wrote:
>
> On Thu, Oct 27, 2011 at 01:30:08AM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Miche.
> >=20
> > The git commit 361162459f62dc0826b82c9690a741a940f457f0:
> >=20
> >     hvc_console: display printk messages on console.
> >=20
> > is causing an infinite loop when booting Linux under Xen, as so:
>=20
> Ick, not good, thanks for letting us know.

Indeed. I am wondering why it was put in a tree and sent to Linus without
any Acks or even being replied to by anyone.  It appeared in the tty tree
between Oct 14 and Oct 25 (while I was unfortunately on vacation).  If
anyone had tried to boot this on any PowerPC server, it would have been
immediately obvious (as it was when I booted Linus' tree last night).

And the original author expressed doubts as to his understanding of how
it should all work anyway.

Just a little more care, please.

I would vote for reverting the original and having it resubmitted with
corrections at some later date.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Nov_2011_12_13_09_+1100_lsOPgMWQm04RXl/E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsJklAAoJEECxmPOUX5FE9UYP/2GMqOVKG+lC9uiq85ulDaGJ
rIfH6kGOwyMER5NpeTdJM4XaOnJwVKum0R4vA1F/Uz4JpO7CtWZjc8+bOYyGHLtV
uVc1Hf8dv8hLmy0YEFuVE+SvuacI70txycM9Uv6eGEYvCwh/c1BkOZk2/kb27vK2
zkDQ24l7BblWIm3fE31xPgtH8X2mmmHrMpdbq1fmOxz83Xa3IS82yksD0/fGjDNn
54RLMtxXwe4bdIRiDhUxLSqJT3UKmXZRiI24SwzSNzC//rIxxe9M39CaxWHCdWXL
0PCEbzE2EQof7aWypkDVJmOHYQGNg2uxdP7ZxeNZNkGR7scblvxHxtq906/xG53N
uVg6e6qS8CwjHPMlQl6WSRTBEXReMDKffeAQ9aACEvQAHtFW1HVqDOLSU1lS45vy
Y9LRGMB8WqvsLw35MaY74/yidnD60Zgl2pDN5KL2RTfh1wgEGh5YilunXvCxaD8l
J8hHXpFtG0n1r/pfsq876AGmNEnOF1IdfFmrsa8ZnUnCKNgGAuw7cUem8X8t7k8y
U1KM6Qu0cWdaCVMcvAP3bcfKlYYgYnclDxH/jXtjgFJlujb3ZZ5Yj4IHaq3mDS2I
A1qWnbU3FvI5ck5C81gEUqoL0Zp5EeN7g9wDLGVLKPO3f/HH7sMONlAL8nmBhyna
YbsmYz14IPXe4mZ02U2c
=/vwG
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Nov_2011_12_13_09_+1100_lsOPgMWQm04RXl/E--
