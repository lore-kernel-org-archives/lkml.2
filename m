Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2DYEpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:45:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab2DYEpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:45:05 -0400
Date: Wed, 25 Apr 2012 14:44:52 +1000
From: NeilBrown <neilb@suse.de>
To: Chris Jones <chrisjones@spin.net.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.1+ kernels unbootable
Message-ID: <20120425144452.32a803fe@notabene.brown>
In-Reply-To: <20120425142001.2cb7a79e@ubuntu>
References: <20120425124925.267056b5@ubuntu>
	<20120425132122.11280b66@notabene.brown>
	<20120425142001.2cb7a79e@ubuntu>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7DdHmrBeqwfRet8DrehrPvu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7DdHmrBeqwfRet8DrehrPvu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 14:20:01 +1000 Chris Jones <chrisjones@spin.net.au> wro=
te:

> On Wed, 25 Apr 2012 13:21:22 +1000
> NeilBrown <neilb@suse.de> wrote:
>=20
> > You might like to try=20
> >  a/ describing your current system in more detail.
> >  b/ describe what actually happens when you try to boot a 3.1+ kernel.
> >     It is rare that absolutely nothing happens.
> >     Also describe the provenance of these 3.1+ kernels (do you compile
> >     yourself, or get them from a distro or....)
> >=20
> > NeilBrown
>=20
>=20
> Thanks Neil. I use standard x86_64 Intel CPU system with 2.0GB DDRII
> RAM on a Gigabyte GA-8VM800PMD-775-RH motherboard.
>=20
> This happens on both Ubuntu and Fedora kernels. And in fact, any kernel
> 3.1 or above. It's not only very odd, but also very annoying.
>=20
> I get to the boot screen and when I select ENTER to boot into the
> system, my screen goes black and then the system reboots. It's
> definitely a kernel issue as anything (as mentioned already) with
> kernel 3.0 or below works just fine.
>=20

You have a couple of options here.

One is to use git-bisect to narrow down where the breakage is.  This means
building about a dozen or a score of kernels and testing each one and then
trying again.  If you are happy building your own kernels and have an
afternoon to spare this is probably a good idea.  There should be plenty of
instruction on the web about how to do this but if you cannot find any feel
free to ask.

The other is to try turning features off and debugging on.
Many distros have some sort of "fail-safe" boot option which disables things
like ACPI and known-problematic drivers... though with it failing so early
most drives won't have even tried to run.  I'd guess an ACPI problem, but
that is largely because I know almost nothing about ACPI so it is easy to
blame it.  So try adding "acpi=3Doff" to the boot args.

Linux has a thing called 'early_printk' which allows messages to be display=
ed
even before the normal drivers are loaded.  I don't know much about enabling
that on an x86 system (I use it a lot on ARM though).  You need it enabled
when the kernel is compiled, and you need a boot arg to enable it too.  May=
be
if you manage to enable  that you might get some message printed.

Or maybe there is some other much more useful thing you can try and someone
else will chime in soon and tell me I don't know what I'm talking about and
explain in detail the right way so solve this problem - that would be aweso=
me.

NeilBrown

--Sig_/7DdHmrBeqwfRet8DrehrPvu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5eBRDnsnt1WYoG5AQJzKhAAt7pLYbaHuzS90vGYL87c7Tpt+AeU8pUA
vEYCy7V3ywbsy0EBLUnrhdLOcywPNp9/6lUlTMGRT1pJ0YpWzu7Fp/NH4Wdk0Jec
QuO9xfuPuOo/OKo1eBxfJY+T7Wq9yDLQdECYr/YV2Cf5dpFNOSZFglD/VffVsU1I
rTx/mX3j3R2XfNCmnB2PBgaEFw4+PBrFsE41/YHIgpXcLACDursUaGt9jlNq6xX1
XSQz9mSlVfxG8gic/7Q7Eq2z3+OaGVCKiq3y9FNy/V9QzbksDxIdRHJHgjJLUjPC
JKgEA1njxmXOQvy8uUjkCKbuYqDaaTwOCMNZWntyGgH9Yi3jwo7mzXXL1FQzxjuC
taclXYcZotzJvNNyeGDc2X7dBBhL7bCAXKBVsVV/IO8KjlvRazt/Am4tCnHNICab
hT0mcuo8J4kbZ3z/NUehjkoz5t2zVkt9pPaKV9hOW4A0qwQOeKyRnrpFWaT/fZkD
b5WVcKiZ76C7+S/YgMh+9IT7Hqv6hYRwkIFSmjIJUKXdwPihWI1nUYgs6CIzfh86
02jOlg2nc+bQ0oFx5TQfjgXVRhWqjyj9Kgp6Z24ss3VL0LXh3KierBBGmh5kwI+W
J0M25H7AElWD9TqNpmv31crsC4fwD8hvJ+mVG0zsWQVBBiPE093PVMOxm/F9hzTw
9GK5gUTCpW0=
=3cc8
-----END PGP SIGNATURE-----

--Sig_/7DdHmrBeqwfRet8DrehrPvu--
