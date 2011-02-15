Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1BOBiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:38:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55816 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557Ab1BOBit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:38:49 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, Slava Pestov <slavapestov@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1297733613.23343.92.camel@gandalf.stny.rr.com>
References: <20110206232253.378726212@pcw.home.local>
	 <1297725267.3104.84.camel@localhost>
	 <1297733613.23343.92.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BnQfVmxQfCSV6i76eAxv"
Date: Tue, 15 Feb 2011 01:38:39 +0000
Message-ID: <1297733919.3104.126.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [PATCH 20/23] tracing: Fix panic when lseek()
 called on "trace" opened for writing
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BnQfVmxQfCSV6i76eAxv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-02-14 at 20:33 -0500, Steven Rostedt wrote:
> On Mon, 2011-02-14 at 23:14 +0000, Ben Hutchings wrote:
> > On Mon, 2011-02-07 at 00:23 +0100, Willy Tarreau wrote:
> > > 2.6.27.58-stable review patch.  If anyone has any objections, please =
let us know.
> > >=20
> > > ------------------
> > >=20
> > > From: Slava Pestov <slavapestov@google.com>
> > >=20
> > > commit 364829b1263b44aa60383824e4c1289d83d78ca7 upstream.
> > >=20
> > > The file_ops struct for the "trace" special file defined llseek as se=
q_lseek().
> > > However, if the file was opened for writing only, seq_open() was not =
called,
> > > and the seek would dereference a null pointer, file->private_data.
> > >=20
> > > This patch introduces a new wrapper for seq_lseek() which checks if t=
he file
> > > descriptor is opened for reading first. If not, it does nothing.
> > [...]
> > > --- longterm-2.6.27.orig/kernel/trace/trace.c	2011-01-23 10:52:37.000=
000000 +0100
> > > +++ longterm-2.6.27/kernel/trace/trace.c	2011-01-29 11:42:07.28706721=
5 +0100
> > > @@ -2041,17 +2041,25 @@
> > >  	return ret;
> > >  }
> > > =20
> > > +static loff_t tracing_seek(struct file *file, loff_t offset, int ori=
gin)
> > [...]
> > > +	.llseek		=3D tracing_lseek,
> > [...]
> > > +	.llseek		=3D tracing_lseek,
> > [...]
> >=20
> > These names don't agree!
>=20
> What don't they agree on?

Whether seek is spelt with an 'l'...

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-BnQfVmxQfCSV6i76eAxv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATVnZFOe/yOyVhhEJAQIzCxAAhZF/nNRXaYw/QKSgcTFp/Kn1b5BGAbdx
l/3tPv4SELoXGwgeDBSM7Ijpr37XbhOVqKn0dMmuXaNGUBbwckhxS5c42zxsXnTc
bNZYH5fJNaRWsCTctpGMfG8VfWz6WTbyGBvMtR5D2L3AN366+jduRnXonLbhjrbv
a3Gn1YEocZRd4ecRC1fgREvFva8JgxtawFr9ZYJb7gZlatavjdzPfi7jTPtCGYIb
sgLUXXsPneJeLbAsF0HtpDzeeCt/OiRqvtye8ivUf68SuZ76wduXhkIstTCXhNHK
7TGoFUg29pMT9mG17G/A3okupnIjnLyk2JH9nVPfsKJTrTrGb14v9tMbw/ZMxAwn
qPgu/9wUCKfvY8GzSzFG0DvvQaQVaFpV78hkDZyfe01lk+DZhVJHxH4FQFcyIueS
tBiO9HH5giFAi81IuGDdNsR0p16qulmiXfGsDfFQr+G3wMeagNkNY3P2+6hOOADI
Ko53io3GVFKGWyIABXgcrgROSkILVx8LIHKBupERbWIXX5wcQ0CfI4lZWEpQsQLa
zOnYwKzNlhbAwmi3Q5ZR7WSKF4ryBYn55+h+1MOIyzjXfdUiB2AZ1I9LTukcZG23
xos7TUh3MsrhYOynQainyUnKwDDEuDeaNXqeQiVGtGX9TrevNJ627TylI/x6Psxy
+MLXNwGtyEg=
=MO/v
-----END PGP SIGNATURE-----

--=-BnQfVmxQfCSV6i76eAxv--
