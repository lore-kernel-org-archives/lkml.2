Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab1HXWyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:54:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51025 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1HXWyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:54:37 -0400
Date: Thu, 25 Aug 2011 08:54:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        edwin_rong <edwin_rong@realsil.com.cn>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging tree related)
Message-Id: <20110825085420.521cc24fddadc7753dc67199@canb.auug.org.au>
In-Reply-To: <20110824211646.GB9707@kroah.com>
References: <20110824154741.3cbe03b403b646e2a99d63a2@canb.auug.org.au>
	<20110824211646.GB9707@kroah.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Aug_2011_08_54_20_+1000_7XakyOQaYFpsVZtp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Aug_2011_08_54_20_+1000_7XakyOQaYFpsVZtp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 24 Aug 2011 14:16:46 -0700 Greg KH <greg@kroah.com> wrote:
>
> To fix it, all we have to do is include linux/vmalloc.h, right?  Or is

I would assume so.

> ppc "special" in some other way regarding this call?

I assume it happens just because vmalloc.h is implicitly included by some
other header file on x86 and not on ppc.

This is why we have "Rule 1" in Documentation/SubmitChecklist.  Relying
on the implicit inclusion of header files is bound to trip us up on some
architecture or platform or combination of CONFIG options.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Aug_2011_08_54_20_+1000_7XakyOQaYFpsVZtp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVYEcAAoJEDMEi1NhKgbshdoH/3cqPVlpKBPYpvZolBD9nWbF
ZudHqcSXOMM/qck+gkeTX+H2PZlNq0J9Va0yE89XBS0qtmGfH0cuYmgPawGVp3jx
6iI7hB4CDH9NecBkxXCnTtoxSO+mNxfdDZZANYJjigOXJ/TdGoT86HU1XALjX+BF
NaZMPG5YeVHlG0DBwfD9uXGRhpmu3YfDn0E0L1BJvTanx7wdE2YAP4+2NdKk/tFt
/0n2y4rzHROG3zpxJ0r+KgQUsd5r24L4y1EYrlgKvqEKyIOQs49Cv/erZHJlRZd6
UgisFNLOjP/X9EyNLUxC4TgTaXbR7+HAdPJ7DHINOgSlToKt5SnlShh4qaLY5no=
=4wOe
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Aug_2011_08_54_20_+1000_7XakyOQaYFpsVZtp--
