Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0KIXgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:36:54 -0500
Received: from ozlabs.org ([203.10.76.45]:56000 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab0KIXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:36:53 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <gregkh@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20101109221338.GA19947@suse.de>
References: <1289339119.2191.92.camel@laptop>
	 <20101109221338.GA19947@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kOVRoZWi8KWI7d1wzZ2i"
Date: Wed, 10 Nov 2010 10:36:51 +1100
Message-ID: <1289345811.10536.8.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kOVRoZWi8KWI7d1wzZ2i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-11-09 at 14:13 -0800, Greg KH wrote:
> On Tue, Nov 09, 2010 at 10:45:19PM +0100, Peter Zijlstra wrote:
> > The below is a RFC patch adding dynamic type ids to perf.
> >=20
> > We need to represent PMUs in sysfs because we want to allow multiple
> > (loadable) PMUs and need a way to identify them.
> >=20
> > This patch creates a new device class "pmu" and adds a single attribute
> > "type" to it. This device attribute will expose the dynamic type id as
> > required by perf_event_attr::type.
> >=20
> > The sysfs layout looks like:
> >=20
> > [root@westmere ~]# cd /sys/class/pmu/
>=20
> You missed the embedded track at Plumbers where we talked about never
> adding another class to the kernel.  Please use bus_id instead for this.

At least in the examples I've seen creating a bus requires a lot more
code than a class. Or is there a shortcut I don't know about when it's a
virtual bus?

(Interested because I have code that is using a class)

cheers


--=-kOVRoZWi8KWI7d1wzZ2i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzZ2xAACgkQdSjSd0sB4dKYBQCfWeTdWA702YoEQVBOuFZoAki4
h2sAoKXuF7hGZA+pGFFpyG2u4iD3DYua
=/VgC
-----END PGP SIGNATURE-----

--=-kOVRoZWi8KWI7d1wzZ2i--

