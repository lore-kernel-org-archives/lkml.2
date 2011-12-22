Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1LVQ7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:59:13 -0500
Received: from home.keithp.com ([63.227.221.253]:42558 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1LVQ7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:59:11 -0500
From: Keith Packard <keithp@keithp.com>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
In-Reply-To: <20111222014520.7ace1ab2@x220.fritz.box>
References: <20111221195410.5e4c065a@x220.fritz.box> <864nwty9sq.fsf@sumi.keithp.com> <20111221222626.0b8c3a30@x220.fritz.box> <861urxy1pw.fsf@sumi.keithp.com> <20111222014520.7ace1ab2@x220.fritz.box>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 22 Dec 2011 09:00:15 -0800
Message-ID: <86y5u4wnhc.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Dec 2011 01:45:20 +0100, Udo Steinberg <udo@hypervisor.org> wrot=
e:

> I quick google search suggests that at least some of them are too old to
> support SNA.

Sounds good. If you can capture the error as Daniel suggests, that would
be great. In any case, I'll post a revert of the semaphore enable patch
as it looks like that's still not working right...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTvNiHzYtFsjWk68qAQhbfA/9EIaYSb1HEFgth0GrL7rOEdcf1gg1dWgZ
zcR8DW4FM88XggrFfKddDgiIIfLyb9mOOT2Q5HwnGp2TTBQkI+xQIPa631mIHRmz
dNhtutTE6sRN1OQZFmfDnqSFdCs797rtMl5LizuleIFvYeUrQbaAysczTHljxR+g
kYuk5K5+lLa1rutMq54QxYJ+iHgZlFjPCrZ+Q8E2USiM//D60AGch8JhmwaB1gk3
Eg5ZKOkbTAijmZeuaZjUTTKIQBsHg92Y2tNortuYEuJU9uNSxhq6pkLwkJd9R8Mf
zKSUxzxwBPhl5/5XfJtDAKvToRL3I6RGUh8Aez8q/oIsyRqHKlC+ymPXNRbEfCXY
Qi5KShdqsQQRc8vvl2mHZzUr0iVQWQK9QCFKImLw7dEZXn+I0ChhOtYwYw8pdWD7
aJhqmzRndm4HS1Kpk80ZYTrfYBHd4dHtlRNbEK7eQT18SYvE7dwPgUPlgoGRxEkY
W0KWaVV3a9cDm5ujFd0GxJd9MBl67mBm7kVwo8skNVgQJtQ25QjD0KrrZY2nGAHJ
9cSxL1a+0BcxXeNwGY7syY03IkHJ84jdsuU6XLWzDXo83HaTm67jwgWiSojxjhVX
uUs349qMj6iXEg6Wmq8W1QalZCO5Bp20ICz4mM/4ThgVbXky/lTav+cuGIAX26v8
D0OIQpc5QDk=
=ucpK
-----END PGP SIGNATURE-----
--=-=-=--
