Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0FER1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:27:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab0FER1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EKLmjZK3QHpXfZ5DcoozimWkwBaGKOX/bfpDLDL9Pthn1nxpmmLh+wX7G5ULCni/Tg
         azlpUUBinDXZvIW4kK4YA9Xl8+P4ioi2wfoAoOQoGuwsyAKzrYk8RorjecjTvVjyPa4+
         +yQ/KTFdeNZzyA5sCoiY3e3x8vzB0LZefEyXc=
Message-ID: <4C0A8909.9000608@gmail.com>
Date: Sat, 05 Jun 2010 19:27:37 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Arnaud Patard <apatard@mandriva.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] [STAGING] Cleanup xgifb driver
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected the subject, sorry.

Il 05/06/2010 18:04, Riccardo Magliocchetti ha scritto:
> Hello Arnaud,
>
> here you can find a few patches that remove unused code, please review.
>
> thanks,
> riccardo
>
> Riccardo Magliocchetti (7):
>    Remove linux version ifdef.
>    Remove WIN* specific code.
>    Remove TC specific code.
>    Remove X specific code.
>    Remove linux kernel specific ifdefery since it is now the only
>      platform supported.
>    More osdef.h cleanup
>    Fixup compile warnings on x86-64.
>
>   drivers/staging/xgifb/XGI_accel.c   |  216 ------------------
>   drivers/staging/xgifb/XGI_accel.h   |   13 --
>   drivers/staging/xgifb/XGI_main.h    |  118 +----------
>   drivers/staging/xgifb/XGI_main_26.c |   41 +---
>   drivers/staging/xgifb/osdef.h       |  119 ----------
>   drivers/staging/xgifb/vb_def.h      |    2 -
>   drivers/staging/xgifb/vb_ext.c      |  329 ----------------------------
>   drivers/staging/xgifb/vb_ext.h      |    3 -
>   drivers/staging/xgifb/vb_init.c     |   55 +-----
>   drivers/staging/xgifb/vb_setmode.c  |  409 +----------------------------------
>   drivers/staging/xgifb/vb_util.c     |   59 -----
>   drivers/staging/xgifb/vgatypes.h    |  118 +----------
>   12 files changed, 14 insertions(+), 1468 deletions(-)
>

