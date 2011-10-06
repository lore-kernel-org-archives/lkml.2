Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab1JFVD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:03:58 -0400
Received: from home.keithp.com ([63.227.221.253]:49667 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab1JFVD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:03:56 -0400
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PULL] drm-intel-fixes (drm/i915 driver)
In-Reply-To: <CA+55aFzR91rOstOcAUoTXGHvztqG-aB-j37_p3F9C3-Ngc_6dQ@mail.gmail.com>
References: <yunpqiikeut.fsf@aiko.keithp.com> <CA+55aFzR91rOstOcAUoTXGHvztqG-aB-j37_p3F9C3-Ngc_6dQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 06 Oct 2011 15:03:46 -0600
Message-ID: <yunlisxltn1.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Oct 2011 10:12:57 -0700, Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:

>   [drm:ironlake_update_pch_refclk] *ERROR* enabling SSC on PCH

Thanks. I've got a patch series that fixes a pile of refclk bugs which
is still out for review that should fix this. This error should be
harmless, but still..

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTo4XsjYtFsjWk68qAQg2TBAAsT/jZQSt4wOWE6XtBiFh+BYhKDnpW/s0
Wi0Iun4Q8g+HkeiAQ7v80+CqJtxk+S7N1ZJOcrDTdkTXsLyMAcZUTBA2JfcvLYxG
Ciu5XvNGT1o2qovzUFB23yVBg4VOA3TFq5LrQJQiCDRp3AAFCamMygS/5BIG7Rw9
M3qqNqmQA78wPrjxMCmFcah/HdJFcNFHOuvreU2PBBG42bu3Yp2D8s4swTZnhNHt
DKnGwwTviU+S/A153Z/GN2Tie6oTUasrNAG9hr41+RpMvrwMBck5QfoRN5b4R3MK
IHFDs34iTZfSm8z8lSTO2hFJz6SDBfCgHxp1HzGTyzl8TZr0HHxI+8Nl3NcrNtN6
QbbOAAIDl9AQwd5mV8S0Nzs/nCbb9HjrV/dyzkRfA20zkTz1xdNcgIZs9OWiuwk7
/Ve3NVklnSxJpMIbs8FWvDkx301w2v9upC4JsXzdj4wp3sq9Il6YfjiGgq4892Dj
kJfMU5aK2PTiRQEvvEDWYREvf4aGf5hPIXiO9/4gmDn1j1PdpqguxWGSMeMgGXhR
ReNqX/+Qz3gHAf0+Dcpi9TZbKu+LpXNhYdkGUHPESlMTD8lpwKVoxYedbIFWWJA1
gUeYYhR2R8SfpM6Ryg7VNQJ06BzTVaJlivMq8l9KcsQTKVysQzjlnmyghZ1o773M
6uBSxKnpmRA=
=P2QP
-----END PGP SIGNATURE-----
--=-=-=--
