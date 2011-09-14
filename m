Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1INGWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 02:22:38 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:50296 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1INGWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 02:22:37 -0400
Date: Wed, 14 Sep 2011 16:22:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20110914162227.4aa02bbbad3be0a9dacebda0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Sep_2011_16_22_27_+1000_wQnV6LmwWmDubnGw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Sep_2011_16_22_27_+1000_wQnV6LmwWmDubnGw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/time/alarmtimer.c: In function 'alarmtimer_rtc_interface_setup':
kernel/time/alarmtimer.c:106:26: warning: ignoring return value of 'class_i=
nterface_register', declared with attribute warn_unused_result

Introduced by commit 8bc0dafb5cf3 ("alarmtimers: Rework RTC device
selection using class interface").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Sep_2011_16_22_27_+1000_wQnV6LmwWmDubnGw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcEgjAAoJEDMEi1NhKgbskfwH/3FKmxIDx7LQEnqRppJrhZLK
1UyMIeA8f8CROw8iAnMyj/68Gj0RWvZUkyc1FPxZ9xMJtx1QQrgJ3G3LzJeY3/4U
NQsAYiLSnWCVprStW1o1GFDhxjCDnZEIzitZiw7AyOFpYUqGZH/tEXR8I4cyiO44
34ccqeh+CEPuDpbBGK8IgDGjZPtWJ1yjqYU/BWXJVrYraYwPP+eM+CZvYIKGsSqp
d0qVj3GtngZJjr6zDu24PVZ+Ike3szteX3/boPJxmanPsdKEVYJ5EiunQbIjAY8x
XxaKEGiczwadiBqOLTE/oClWx6isTfp0w52GVT3X6M3bvG5MKu6jneb4aQ8hhKo=
=xy7q
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Sep_2011_16_22_27_+1000_wQnV6LmwWmDubnGw--
