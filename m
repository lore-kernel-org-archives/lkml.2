Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2IPP7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 11:59:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58047 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab2IPP7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 11:59:15 -0400
Message-ID: <1347811144.13258.281.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 0/3] 3.2-stable timekeeping fixes merged in 3.6
From: Ben Hutchings <ben@decadent.org.uk>
To: John Stultz <john.stultz@linaro.org>
Cc: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Sun, 16 Sep 2012 16:59:04 +0100
In-Reply-To: <1347402926-34813-1-git-send-email-john.stultz@linaro.org>
References: <1347402926-34813-1-git-send-email-john.stultz@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-I+BSdaxWgt5annBvlZWI"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I+BSdaxWgt5annBvlZWI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-11 at 18:35 -0400, John Stultz wrote:
> Just wanted to send out a few timekeeping fixes that were merged
> in 3.6 which are appropriate for -stable.
>=20
> This queue backports the following fixes:
> -----------------------------------------
> cee58483cf56e0ba355fdd97ff5e8925329aa936    time: Move ktime_t overflow c=
hecking into timespec_valid_strict
> bf2ac312195155511a0f79325515cbb61929898a    time: Avoid making adjustment=
s if we haven't accumulated anything
> 4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b    time: Improve sanity checking=
 of timekeeping inputs
[...]

All queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-I+BSdaxWgt5annBvlZWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFX3SOe/yOyVhhEJAQpoRA/+IdDikzeDWqMamVAtrbRwPgh8DsH4Lyq+
sW7PRGfglTdrdPNYHxyGwn11PZEe7cRUlQWM85Wk0wxA/+lVkr+FjCEdxD1BhAfA
g07/IYJbA8Ke82TViWHyOEaIpO31o3gQJmRjTfRgDh3kyDuNxVJN1kszcS9w+wda
EECXdZLdFYjO91L9w3yWcxnPVSC9Z2JING40spfq+yzemLZb+dB6qHw9I4uCBw6S
0EvSh+16MCd7VvpFLuLpQVaRhOXOTgP7sLYqKUdSVRjjsWZTRQJHXqqzGodFgic3
aYqQdEIWgMdC1/CEIh2/Qw/b1B7uYbm+g1wTngao0kfm7Pd08GckaVdGeeUO6YKN
ifzitZPWwRdElOZNga0/m1f3SzmaaLtu0+5RqQz2yBTHev3qHrdZV7j6Y7EtcRLW
NEfwWcZbTZtnCW5BMgJJdHZxcCJvPXFkuIc6SCwuWPC+Jcf9EJIHs9gjnW9ZdtkJ
k1Axc50a9J7hTVSvG+luTWDp6zkkkq7Zq/HXCf6S/CbfH+n28aTM++PHnq2xENoL
GQi/JQeNQQMwtIXCr05owDfvu536XhZ/O9lnBceXvbRpTT8bO2nf3SdQ42UL2Bhf
Yxm1QjGN2RccoFlGW6Lb54yy0l8378gzgf/5XvRqS+NyJPizUL7/+WXuNjmk4lEP
YjIcmce5VaY=
=vmkV
-----END PGP SIGNATURE-----

--=-I+BSdaxWgt5annBvlZWI--
