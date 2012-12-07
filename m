Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab2LGXQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:16:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:17934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab2LGXQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:16:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,241,1355126400"; 
   d="asc'?scan'208";a="230542435"
Message-ID: <50C278D5.200@gmail.com>
Date: Fri, 07 Dec 2012 15:16:37 -0800
From: Jeff Kirsher <tarbal@gmail.com>
Reply-To: jeffrey.t.kirsher@intel.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joseph Gasparakis <joseph.gasparakis@intel.com>
CC: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        gospo@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, saeed.bishara@gmail.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH v3 3/4] vxlan: capture inner headers during encapsulation
References: <1354845419-22483-1-git-send-email-joseph.gasparakis@intel.com> <1354845419-22483-4-git-send-email-joseph.gasparakis@intel.com>
In-Reply-To: <1354845419-22483-4-git-send-email-joseph.gasparakis@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigAEEDBB0E151006AA596EFEC4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAEEDBB0E151006AA596EFEC4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/06/2012 05:56 PM, Joseph Gasparakis wrote:
> Allow VXLAN to make use of Tx checksum offloading and Tx scatter-gather=
=2E
> The advantage to these two changes is that it also allows the VXLAN to
> make use of GSO.
>
> Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
>  drivers/net/vxlan.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>


--------------enigAEEDBB0E151006AA596EFEC4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJQwnjVAAoJEOVv75VaS+3OVZcP/2VcS1cNkji1YYy/1GrveUTK
+Xsdp4pdttKPi1to3oa2PMZom8BzMSbwaAarPasnLMY1cLMcKtIrKB53OGbTW+9+
4yVSQ/1XWKHXk/ZBf8sseh3PL11ar6p43UQwipjBav9iau6JUuOtIy2ZXLxzS9lX
h3xLUABFw6jNDLQ2YCAe/IeKBrFsO3hIDD9A9a1MCF43qve8c6TeXDTY9ojUDUTF
gnzSrFFB7nEmcyqVE5sejoplWLbXKzPV0h4P5MeSTMZPm8+28rcPVOexDOkZcEoZ
gXqhsbTmjhj2DEIS8RlFz+Q6PiZ5odtHJS5mP1VIbK8BMWzu9moAMIlbgbn2kPpP
JrXguH7Msm5XrIQCv+F3pRyMA3oofxPeKNRZZAH/7JBlGsoaKxn5d6XkHeniGiUs
6li2gkzk7Ae0C/Kk87C4kzAZHLywdozfskD+GEJ1OTFWz08m3S8oSeGjnTb3DY23
O9ZftFkOYYHl2XW2Ltl0Ns9gPVQh63FM6+lHJFeQiAnFyURxWrGD34odWWp8wlM2
Ci7Od2pcrDGr4n0ZS7v2i3GY4Iqjij4VS9YISR2CuqlytvRi5XTRaiVYCQIbc0TK
iFK/b91/k8XWle+I1TKg5MpDiF1H04n7SqBuKc94KUB4lxwiOIgd4Z4DC5EhgQb1
2e9xP0mWAIpedCs9JZ15
=b2iL
-----END PGP SIGNATURE-----

--------------enigAEEDBB0E151006AA596EFEC4--
