Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2GCLFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:05:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44925 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab2GCLFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:05:23 -0400
Date: Tue, 3 Jul 2012 12:05:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alessandro Rubini <rubini@gnudd.com>,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120703110520.GI29030@opensource.wolfsonmicro.com>
References: <4FECB95D.7010200@zytor.com>
 <20120701104401.GA4352@mail.gnudd.com>
 <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
 <201207021658.27755.arnd@arndb.de>
 <20120702180518.GA25995@sirena.org.uk>
 <4FF1E37D.7050103@zytor.com>
 <20120702183324.GA29030@opensource.wolfsonmicro.com>
 <4FF1F987.3030501@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WHz+neNWvhIGAO8A"
Content-Disposition: inline
In-Reply-To: <4FF1F987.3030501@zytor.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WHz+neNWvhIGAO8A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 12:41:59PM -0700, H. Peter Anvin wrote:
> On 07/02/2012 11:33 AM, Mark Brown wrote:

> >> Last I saw I saw a patch to that effect, asked what the benefit
> >> was, and got no answer.

> > Are you positive about that?  I don't recall you replying any of
> > the times I sent out the patch and my mail archive isn't
> > contradicting me either.

> I said last time I saw a patch to that effect; it might not have been
> from you.  I might not have seen yours for whatever reason (including
> losing it on my end.)

I'm kind of surprised anyone else has been sending stuff (unless mine
got resent by someone else, I did include it in some of my serises for
the clock API); I know I've posted mine several times now.  In any case,
I hope the mail you're replying to answers your question about why it's
useful.

In general I'd probably go further and say that (at least when a generic
implementation is available) there should be a very good reason for not
enabling an API on an architecture rather than the other way around.

--WHz+neNWvhIGAO8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8tHWAAoJEBus8iNuMP3d5sUP/RGmlvwsVzYuojMtOmKiG5Ce
ipKXHvQWqnuFbMcW0ZgauSYVy8vq4C1R/gjkAB9Kt/2zGWPWfTozVk8Qazti+WPK
ASgxVmpX4vY2ArzXMuxnMPuMoINS2kM9G2te1Fi4iyauuuSZH0Fnue0FNkAQu4lN
T+/fLBJJg2ONl+XjTPsXqSmKeCuBzZJayLDWoUjdNnzBMSCEB0dCQxETxUXMdOVz
xIVBTki/His8rhgSkrZ4p0vvNayJYfqPLCLv7vnfYnt6kyGahUsUmMWgU6Fglzc5
+AiotwP5s7FkkmP8x6S8oCQdG2ouzy1YPN9oKQi0KH7yJhj1wQeq5MMTNbY/uuLo
37Ikj3OYp2mD6WT/oMSU4fIe5/TNDa/tqb4qZUafo8pbDtb7K5cYNVA1fTukEkmq
w4GlQ/oJy6G+kHcVbzUCST8qxy6ENnNljafgGFxFEorDPZdnPfL9FYkjIgWz4/by
GuZU/yFbVHTAE1lLR2iZsN0rM5u9PQ0ozz8mJOxEKLC4VZDGc6KVg/tu30tgWhSl
yqSQ3JmkNuCiW+FMdBaD7wwX6fRSOhBs/7XYABrkpmL9dU9m01jb8svh1lIZYWAM
yv6BriIm0Z0JJvCQagFrFPcnaeKCIOYkrFwJuorXw7KmwEXkw2uHXybNqhbrMOGN
OV49/m5b+ukYwNADndAI
=brpJ
-----END PGP SIGNATURE-----

--WHz+neNWvhIGAO8A--
