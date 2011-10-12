Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1JLQns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:43:48 -0400
Received: from home.keithp.com ([63.227.221.253]:42686 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab1JLQnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:43:47 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 19/21] drm/i915: Asynchronous eDP panel power off
In-Reply-To: <CAPM=9twEUUYrLS2_kk-dpa7WzvYhkEGN+B_pqPxKEJZN8o9UKQ@mail.gmail.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-20-git-send-email-keithp@keithp.com> <CAPM=9twEUUYrLS2_kk-dpa7WzvYhkEGN+B_pqPxKEJZN8o9UKQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 12 Oct 2011 10:43:41 -0600
Message-ID: <yund3e22m9u.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Oct 2011 15:41:11 +0100, Dave Airlie <airlied@gmail.com> wrote:

> > Using the same basic plan as the VDD force delayed power off, make
> > turning the panel power off asynchronous.
>=20
> NAK, tested on my 2540p, up to this patch in macbook-air branch stuff
> worked, after this I just get black screen on resume.

Thanks for testing. I've created a new edp-training-fixes branch that
removes the async panel power off and leaves the rest of the branch.

I'll test on a 2540p that I've got access to today, and on the MBA when
I get home this evening.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTpXDvTYtFsjWk68qAQgvyw//X6r8fg1bc8q1ZB6wZ1Tv7olisdvfGikr
MK8w0ImzKuC9zXtVf4YwWhlxKOVaMKqhvITJcLtLEftFvIhjH9zX7JHhrNGQjGj6
exkO/sWbsVhw/AIED7YmFFZFWpEav0dvT4olcw+tmCUmtnRGFtUr0X4siywOwb62
JGwBgJLF2KTLE//kkBKYyE4wVPVbFJBguFU0Rp6g6AGF1kdHG7wJTFzbFp7GdqYY
ilyXoXjgp6OMoBoSvfdi2P4nIHf/vHSdxLKthF6QgKBYTcMSf8FoH7m38uzxh2Ji
ChxS/+M5u0F5zyg4aaJU2jfOIq+cfi+kOdEelXEHWsSIqP4vM5X8vXOwxrQt7N8J
IBt6vGs9J1yBl7utQ1F4Uao6FuRQ82+jzlTAK17Zz8hlRmp88EFJF9OTMNfVj2F/
IhNStOH9bAUQpkei5AYmGx0ONl/wxcNY8HI6TXJmWVkBz1MMDb4njuxOCxhzxpDL
EX2jn9XJBRe3tVv/4yvSN7GdayNQr8x24YzitSI2LVulOqNx3xNhBlDyB9xszilc
zV//wVkNi6M0uWy7y2GeodV30zGKix33S4g+77HEuXo+Yrnmk51zFHLVFMWbgPx1
731Pzqst9OMBzVB7XscT5ttdD6azCyU1KWzLqZz5QbzhtGXQVU9YSEdeBX2BesWK
lydc02i+CaM=
=/8Rt
-----END PGP SIGNATURE-----
--=-=-=--
