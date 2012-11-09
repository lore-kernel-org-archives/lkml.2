Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab2KILfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:35:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46548 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2KILft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:35:49 -0500
Message-ID: <1352460945.4387.7.camel@mattotaupa>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
From: Paul Menzel <pm.debian@googlemail.com>
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 09 Nov 2012 12:35:45 +0100
In-Reply-To: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q24RmoYZa30o0Fn5QosQ"
X-Mailer: Evolution 3.4.4-1.1~pre2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q24RmoYZa30o0Fn5QosQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Jim,


Am Donnerstag, den 08.11.2012, 13:47 -0800 schrieb Jim Kukunas:
> Optimize RAID6 recovery functions to take advantage of
> the 256-bit YMM integer instructions introduced in AVX2.

in my experiencing optimizations always have to be back up by
benchmarks. Could you add those to the commit message please.

> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>

[=E2=80=A6]


Thanks,

Paul

--=-Q24RmoYZa30o0Fn5QosQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlCc6pEACgkQPX1aK2wOHVggMACfebjW0Qn6Eaq0Sw/adM91N97B
wv8AnRkNMQwR5bbpuFVZ7VSd4sWjsrss
=FhLT
-----END PGP SIGNATURE-----

--=-Q24RmoYZa30o0Fn5QosQ--

