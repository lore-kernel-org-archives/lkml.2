Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412Ab2ERAiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:38:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:43026 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761734Ab2ERAiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:38:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 00/10] Use __kernel_[u]long_t for x32 user space compatibility
Date: Thu, 17 May 2012 20:38:46 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc6; KDE/4.6.5; x86_64; ; )
Cc: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@kernel.org, tglx@linutronix.de
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <201205172019.27462.vapier@gentoo.org> <4FB5960E.6070205@zytor.com>
In-Reply-To: <4FB5960E.6070205@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4978962.d8zlrftm2Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201205172038.48371.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4978962.d8zlrftm2Z
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 17 May 2012 20:21:34 H. Peter Anvin wrote:
> On 05/17/2012 05:19 PM, Mike Frysinger wrote:
> > On Thursday 17 May 2012 18:13:26 H.J. Lu wrote:
> >> From: H.J. Lu <hjl.tools@gmail.com>
> >>=20
> >> This patch set changes a number of places where the kernel
> >> headers are exported to user space and currently use explicit
> >> "long" or "unsigned long" to use __kernel_[u]long_t in order to
> >> be compatible with the x32 user space ABI.  These location are
> >> places where x32 uses the x86-64 ABI.
> >>=20
> >> It is quite possible that some, or even all, of these locations
> >> should really use dedicated types, but in the meantime this gives
> >> the correct results which the current headers do not.
> >=20
> > tangentially related, but what happened to the x86 asm/ptrace.h
> > patch i sent that changed all the registers from unsigned long to
> > u64 ?  e.g. struct pt_regs { -	unsigned long r15; +	__u64 r15;
>=20
> Link please?

https://groups.google.com/group/x32-abi/msg/b0b5be30d7aab1f8
=2Dmike

--nextPart4978962.d8zlrftm2Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPtZoYAAoJEEFjO5/oN/WBMygP+gO1rJfkE3Y9WEobAJVirip1
KXgfTeslXcjJNA+b5D5QnGoTvrjhq0BOTlt5EBw55N0Dfke0LOprWc2E8AywVe57
1Yagw+nF6XWfOHt55fwlcEKsU8IoNfEWPGWO1K1bLz7uB3dlSJUDrhzpljsanV6d
xDKmrVGqrKqDZddY/6KEhm+tV1Dek+PwMhpA+vdrH6uJmEMo3kA53BPTiazhdVs1
JcTHeaYOM8Jhzy9aFLSxN+7Alj6oLIrzS+C+3AGmixJhlvB72jyMPPnCzONrbyOz
FSBkyjoM8ssBz4cGnD3HuQXo5+N8KvnP3aNHmahHX5xKtRBJLkT6xllcqk5Z9MJT
qqn6AyZ2lUWa9zSSbmJx+K8oZoLvDVCXVyRFcANWCEyy38KcJ1LyXrx4UgQUn7WT
GWMrOjYr2FXBqZe2bdhEaz5B/AlAoDd91KMWkrkb2r+QiS49rIuPzK9Nl33v+8pv
WuWwvkntLfik6XKyWh+kCXJJx2zkdpe7T3fssEglKa9kEQdSewu583U0MIy2oHSd
SboixACbRAdn0/rJ9TRNFU6Rg+Y7xZzzeM0nOp2xlRkGjKHEX3cUJjEMyQ3vJ1LK
9qUvbkOrjB6QbVr8Y5NCJVYBmwd3wIcXQAdpe/N2paE9BXTQAYskO0OtU7pAPVAs
LzxH1hzWBfPdVV/wn3bB
=0JPu
-----END PGP SIGNATURE-----

--nextPart4978962.d8zlrftm2Z--
