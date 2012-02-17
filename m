Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2BQDZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:25:57 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:44010 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2BQDZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:25:56 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Danny Kukawka <danny.kukawka@bisect.de>
Subject: Re: [PATCH] arch/blackfin/mach-bf537/boards/pnav10.c: included linux/export.h twice
Date: Thu, 16 Feb 2012 22:25:57 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Danny Kukawka <dkukawka@suse.de>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
References: <1329400584-32069-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329400584-32069-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2526128.lnhZrB35Yp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202162225.59076.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2526128.lnhZrB35Yp
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thursday 16 February 2012 08:56:24 Danny Kukawka wrote:
> arch/blackfin/mach-bf537/boards/pnav10.c: included 'linux/export.h'
> twice. No need to include the file a second time in a #ifdef block
> if already included at top. Remove the duplicate.

thanks, added to the Blackfin tree!
-mike

--nextPart2526128.lnhZrB35Yp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPPcjGAAoJEEFjO5/oN/WB8foQAIn2CeTxfFsz1jIBEBETv1rc
3BuFrS1dB1KUmrnTFVsVtyEevc6oOJrmuZ64sg7fpxOHYs5jzP41MjrxNZDQKjUh
CGwN7fJDYR84eNITufRjMIZhGhHioXeXyCp/vd0CP5c/FsqEOJkg8dMbbCd0b1g6
tsMhXisAY4PEvLTTzUkNaPj0BzQMs/1AQQKYxDP/IxlTFhKYl7wVG0lKT1MkCwa9
6vIIFMscQfz9glTnnysUBpK/+c+hyV2yiO+ZzhZU2Tn+dmtJPpiuUpV/YRhRFl1G
xy18JeUXKUcexWztgrJedgwsiVBl8nmH6oQiBnPjAkUYG6xXAZxnKsDKyFdVSnld
TYVeQ6k8RO0ztBlhkW5IuKDdgMMhO1B3eQeeSHww/zrTzFSlIFI3v9PqdLG+WQmb
4aj615z/8qfxFnXg8YmTf80QVFencAahXpEpd1+tg4f3vHO51G8C9VfmUhVk6cKv
cIMHl2Gog4bJ+NY2efr6J+jTU2TMolkfjHZQhxJFGCqH0xhkFz8pvpThxgX0J+VP
bAnmliYgC1L07Q5nUI96o4qouXsfhx1lPYVAL+qaRJ+CN/N5HjaqBj1J61866lYx
aREw4Yc/6PT7XAWwq674Mli3LdSO5cTcwN+hT4ms2xLnWayoLRZ8gFzgxpV+oeZg
3wqyf6woX59Za6r96pnR
=Lpel
-----END PGP SIGNATURE-----

--nextPart2526128.lnhZrB35Yp--
