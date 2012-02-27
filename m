Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2B0AXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:23:00 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39090 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2B0AW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:22:58 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.
Date: Sun, 26 Feb 2012 19:23:12 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: JBottomley@parallels.com, jejb@parisc-linux.org, kyle@mcmartin.ca,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2838396.dFR3c2q4Di";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202261923.15167.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2838396.dFR3c2q4Di
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Sunday 26 February 2012 18:26:53 Paul Gortmaker wrote:
> --- a/arch/parisc/Makefile
> +++ b/arch/parisc/Makefile
>
> -CROSS_COMPILE	:= hppa64-linux-gnu-
> +ifndef CROSS_COMPILE
> + CROSS_COMPILE	:= hppa64-linux-gnu-
> +endif

this should accomplish the same thing in practice:
	CROSS_COMPILE ?= hppa64-linux-gnu-
-mike

--nextPart2838396.dFR3c2q4Di
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPSszyAAoJEEFjO5/oN/WBQ8MP+gKO+u/03HSZFU7qi0ivEVPT
XWmWrSEXYJyKG7tQQrczqKcwx1UcW9x+Eo9cSzkTh7YGTN4S+wACaVfIZLBTdKyW
FPIDumZWFvJQ3r3XXd/ELhHW68ny4yTQgyqT/wNXaWw+cB5rdTvkxKyNkeu371SQ
NryxZYAEoCLfWF0ZITPN9bNEZjj1KsoaKHBr4ApFuHxV15Bjk3RTEY8UhnZrWgQ2
GGfZ61U7f/DbX09TTh3TxQrI06I2Cnh2OU0yW48sDDCjefKo3QRz/5HzT9ag+pPs
P1Fqo+l+VgC4/kiAuBUj533P4S39u/INRXuf0krDYZd5FF/oFcT4X7cDdRV4HpNA
vrCDohCtZGIpG88mjX87Sqcp3XKg1kA55ceFju51zQczzkDnKIuuQTOPeg1SMNEY
Qsirs5nppIUXlKiG5HXwSog2O5zqp+YNuO6cEmpJRhedq7VwLfVbmS9SM2D+OBug
DzIrfZFtm1X/7tlVySl/H5n5/1BelfEGFTm2/Kb7tUOUAbTCxChQBXVLVWlNd9YC
HbTGXKK2wR2SEF9XrWePo2io8XLZNRskUmJ1edkQRLr6LicebM7NsPmR9fJfGIci
N0livuklxfzDGxAe8HuwmcjGqyPnL1Ve8gIKFgb5o6hJpaOXINqvwRJdJ0vtXK4U
jTX3Z4kLJQOSJFfPGvdb
=KY3Z
-----END PGP SIGNATURE-----

--nextPart2838396.dFR3c2q4Di--
