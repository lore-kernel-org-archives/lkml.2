Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2EZPbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:31:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37509 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab2EZPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:31:16 -0400
Message-ID: <1338046259.20487.13.camel@deadeye>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
From: Ben Hutchings <ben@decadent.org.uk>
To: William Dauchy <wdauchy@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, shli@fusionio.com,
        stable@vger.kernel.org, xen-devel@lists.xensource.com,
        Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Date: Sat, 26 May 2012 16:30:59 +0100
In-Reply-To: <CAJ75kXYhPNShZaPduMK2ympVFsu+kTxJfYB5RyGA6cnwfhXwMA@mail.gmail.com>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com>
	 <20120521181558.GA7829@phenom.dumpdata.com>
	 <CAJ75kXbJXVW6dJDzG7zDuiu=6NnTybM3m97gW507-yzzsa7yoQ@mail.gmail.com>
	 <20120524185039.GA14713@kroah.com>
	 <CAJ75kXYhPNShZaPduMK2ympVFsu+kTxJfYB5RyGA6cnwfhXwMA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-B237QvUgrnkWjTM9YtGG"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B237QvUgrnkWjTM9YtGG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-25 at 23:19 +0200, William Dauchy wrote:
> On Thu, May 24, 2012 at 8:50 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > Now applied to the 3.3.x tree, thanks.
>=20
> Thanks.
>=20
> Ben, do you plan to apply it on top of the 3.2.x tree?

Just added it to the queue, thanks.

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-B237QvUgrnkWjTM9YtGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT8D3M+e/yOyVhhEJAQqtpw/+LjWJ2icNBBcXBiC/KRG6Dqr8ocXIFVwV
oUjehd7B8LEhtUw50OKZhGQGIJm+7ODgprqM7nKVps2ytnQzZcBhoWU0xxZLirMx
XoZ0hFdKH3q9DYXXMkgdIvE8t5JMZ4K5Bjx8kg//rbATSrhmu8GnkZ2Cxg4pV+Tr
P8Yu2uOd60lMlWr4+IMa83B30BtT8+J9h6kdR7XyWb4yWGzGuGYTRYOZce96Oh6m
JyKICSR7RkP/F3Q34qnNvvThshMpb2qnYgqKRCY5dEDmzYabIz8iffsRFKK2Euro
sjGrrrYGedLe94G+2yQlnMZcnnYMlAF3MlcHUUkxNRtwWxnY7O/3FgrLLNBZjZ8d
GLGioyuLCY+RSui4XbupS/5MCiSENYx3dEPqi4BPRqefAWP6j3YTocq1i2yghrNx
3PlMCChuP6TPwfwpUW6CnDie0FxN4DzuiOGsH/zETYirzuouSXk/77Qbvkg7pwzp
ymKbErOZmlOswJ4/7B1D8NmFV9dzJGxAJsgjdb+sSWVFJdEQOhiN8LRHhOtslpFp
40WjNsRvDp8WjJpiB8zoh9JwPuDk8XRqR2pa7908CPGBzTCL+oGlteGHFJSITNDI
rrMvqdEy8B3zKlf1kDDyxqXMpt8KyBtXVkW7A/pJn8MJHouchtl6ie0JKpNlRKe1
aFAUgBtLGac=
=lv9o
-----END PGP SIGNATURE-----

--=-B237QvUgrnkWjTM9YtGG--
