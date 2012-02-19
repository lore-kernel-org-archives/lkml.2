Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2BSUIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 15:08:54 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:43628 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2BSUIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 15:08:53 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/5] blackfin: s/#if CONFIG/#ifdef CONFIG/
Date: Sun, 19 Feb 2012 15:08:59 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1639690.0GkObJmljf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202191509.00625.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1639690.0GkObJmljf
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

thx, pushed to the Blackfin tree
-mike

--nextPart1639690.0GkObJmljf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPQVbcAAoJEEFjO5/oN/WB5EIP/2GUjx5zTCv6XWMEw2y/pU/f
pjkXKreeofL+fSazGmU3v6o6UU5HGGLPkrMqs1TKWlrqL7ZoyPnBz1+OsTjAjspg
STOUPu3Dy5+vnvubAevZEuYVa9PlTjHmQlW4BsGmx5Kq+kgF4jIZksoshb81FoLl
kk8JmxrfwL7Ybq4xkN4dKSbnLXYDOx6zAFZEk0CRFAi1m6ogzVq4MMrIcOP5mOVi
S4gwphN7xKBmRQ0213+DNBPZEi/+g81Z2Qz5orEjTXQYm2t5+IsMZSxVtGUDEgey
LWLZ4yz8QrJ6i1sn7NDQihRQ7xlfRGqAi3cCAEDpJkyU7wLh+xExPdSyr8Yk9Zf6
EZ3hHV9RIya7cM4CvbCQENbJcFRrm+tac118flR2HRtU2iOYbQzL0F8rwlht8gzZ
582P7TUmLdyJPO2FIqgSj9oZbqHgkfuNl0uN1JzFM8hqTa0MQmqf1yoVjRvvgw7D
DK9BV4hA3bgwTTFoS9lf4q4+/5qnEEbn978HwKI2pIXJQhPX1u25LMPorK5L8uaV
ezXUOI+XsuuLwOmFA0o4fxv0xER4bGsrS0dYGwp9WyW5XMLRIquNptLHYk03Byna
3eu1E4HYO4IIz1LtQjUAUxooDT1chhVbh2wCZzE74qCu7SZ3xiAtsh96KznT0zMH
I6k7+nvnRJtk0YknMv9y
=BXDU
-----END PGP SIGNATURE-----

--nextPart1639690.0GkObJmljf--
