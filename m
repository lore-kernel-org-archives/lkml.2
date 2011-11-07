Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1KGGTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:19:55 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34851 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1KGGTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:19:54 -0500
Date: Mon, 7 Nov 2011 17:19:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, miche@google.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Greg KH <gregkh@suse.de>
Subject: Re: Regression: patch
 " hvc_console: display printk messages on console." causing infinite loop
 with 3.2-rc0 + Xen.
Message-Id: <20111107171942.fe21429583491475f245aa08@canb.auug.org.au>
In-Reply-To: <20111103013012.GB3449@suse.de>
References: <20111027053007.GA32765@phenom.dumpdata.com>
	<20111027054806.GA1377@suse.de>
	<20111102121309.4dbb0d2ac90d2879130820dd@canb.auug.org.au>
	<20111103013012.GB3449@suse.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_17_19_42_+1100_pjK4iajXXyXmXJ=X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_17_19_42_+1100_pjK4iajXXyXmXJ=X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 2 Nov 2011 18:30:12 -0700 Greg KH <gregkh@suse.de> wrote:
>
> On Wed, Nov 02, 2011 at 12:13:09PM +1100, Stephen Rothwell wrote:
> >=20
> > On Thu, 27 Oct 2011 07:48:06 +0200 Greg KH <gregkh@suse.de> wrote:
> > >
> > > On Thu, Oct 27, 2011 at 01:30:08AM -0400, Konrad Rzeszutek Wilk wrote:
> > > > Hey Miche.
> > > >=20
> > > > The git commit 361162459f62dc0826b82c9690a741a940f457f0:
> > > >=20
> > > >     hvc_console: display printk messages on console.
> > > >=20
> > > > is causing an infinite loop when booting Linux under Xen, as so:
> > >=20
> > > Ick, not good, thanks for letting us know.
> >=20
> > Indeed. I am wondering why it was put in a tree and sent to Linus witho=
ut
> > any Acks or even being replied to by anyone.  It appeared in the tty tr=
ee
> > between Oct 14 and Oct 25 (while I was unfortunately on vacation).  If
> > anyone had tried to boot this on any PowerPC server, it would have been
> > immediately obvious (as it was when I booted Linus' tree last night).
> >=20
> > And the original author expressed doubts as to his understanding of how
> > it should all work anyway.
> >=20
> > Just a little more care, please.
> >=20
> > I would vote for reverting the original and having it resubmitted with
> > corrections at some later date.
>=20
> You are right, I will go do that, sorry for the problems.

Ping ...

Linus can you please just revert 361162459f62dc0826b82c9690a741a940f457f0
"hvc_console: display printk messages on console" as it breaks consoles
for all PowerPC server machines.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_17_19_42_+1100_pjK4iajXXyXmXJ=X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOt3h+AAoJEECxmPOUX5FENFMP/jZOS+gsCITHFxhkyVSMsq4r
b244rYfPYLAz1QBHNGnVkPYOTWGFeNMbmW03AtlJgAyhCBq0WedYTKNhkMFQBEe1
1PwCh19zGx2IURoYeQfV4xj9129sP8YbT6rDuHQKo6hKc7TEYQ4VSKklARgJxzA3
vTjJNzWoV1VFsvE3WCpckH/XwUe9M7LHqDv4HfJmaCxIv8sCqfkLxNiqw245kHou
nnT4dnK2Knwt/384z5dCWoI27hs+nwCAgFtkbioeW3DAmkPk9JHUnGLx1DPa0iru
RIbokSABq2EapKTZb8ig3SGhf8MP1Goby9nit2e/227keF0/cS9UssbH8E6KUB6q
IfMtiq7fn0d79Ukjkkoy17T2swuGQZQyqM4JF3/dt2A9b0mwjRT53vE5r3lUTmCN
oS8g8P3YINTh4uY2+JlhYGoHEUHoYH8vbco/Q3XSbMJnYgT4hInb2z8sJJa5+Rkf
L4nPGFdbxvZoc2tbXRGz7/xdxNMzylqBDTt4VjnXroK/AUSFKTd9I+ReAdJp3/SV
KGbMQ58BfCWXGrCpvpdirIPYglC6nPZa/jk3o5vSr+g9O9TLGMVa7VYcaLWKW5uC
iv2Rs1RjIaimhTTw4Vk237AM3cUWcwB1WDccwCaaNZpNgDzUZtP2ZLnKiKqNFAUu
vMXhZjFqiJK9DZqjkc8h
=HH7g
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_17_19_42_+1100_pjK4iajXXyXmXJ=X--
