Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2EFIPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 04:15:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56343 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2EFIPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 04:15:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/29] blackfin: Use generic init_task
Date: Sun, 6 May 2012 04:16:26 -0400
User-Agent: KMail/1.13.7 (Linux/3.3.4; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
References: <20120430194725.763322463@linutronix.de> <20120430194845.850346878@linutronix.de>
In-Reply-To: <20120430194845.850346878@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3417189.oGjxHQfq1C";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201205060416.28085.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3417189.oGjxHQfq1C
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Monday 30 April 2012 16:15:54 Thomas Gleixner wrote:
> Same code. Use the generic version. The special Makefile treatment is
> pointless anyway as init_task.o contains only data which is handled by
> the linker script. So no point on being treated like head text.

thanks !

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart3417189.oGjxHQfq1C
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPpjNcAAoJEEFjO5/oN/WBfUIP/0au5BWIuaXvwuaVK01tmZGt
lnJLTIdl9OOlQ2+Ij/f8YQHOe82dZCp8fWiw8ytWQhUt4A1aEhghIu41lrA+MC2j
V8sSo1AjcjGbv5KHuDgMt+pLSuIeZSTMKe4qZEkQDfWYDiUN/lMdwvEsu7fhum75
iJgPHWz87YuYDFFvHh7PXLbz2wQ4zkroSdNGcTel7PegT0t3MLiqSCeyB/ojRiXc
OA6APCgwI8/1sEdz6whfMZJUkMEnuyRILqhdgeYUF8SXhCwMcP6w+475y60fmZFz
YfSKkud4k2hdjifmhgm8EK+U0h0CL5f+HyR2QD9mcVSUyhdOQeZOiq7Cfu5C5T2R
3ZkZ56RZLRr4RwB2B/g+rprC9XSbsvku9kSmmEPhSahOs8e9NJWgH7ikUTw9WDwF
xEw7zvI3l/atCfX3JnFVEPtFDhtch3yR8HGpyM9QBsIH7Me+TJTVyMZOEliJp5kz
c3BGU2LONw7Z7y9FTTcbLvwkqH00lhI7t0HpvBeDJ1WjKf5xq3KDLpEJUCohKNOs
k86ri5yLVcmZvlk2PfVGCpJHPJNii2pVEx7CGWtW4EjiW18BRHRyFecP4IIlYuBG
kWjoYCIn5sLtlj3+gfU041S8QQlaQZzudAAN8AOLxKV0frMLBH6TtDGXIarBni69
2Ci44C95h8ukO5Mf/y9v
=zfPU
-----END PGP SIGNATURE-----

--nextPart3417189.oGjxHQfq1C--
