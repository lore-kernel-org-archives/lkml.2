Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1BUUEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:04:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60997 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1BUUEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=a7SnWHF8nYIczshIroEYcfzF87mF+0SNssilu8BDO47PtoT+GTwVZ4KDyKR6GZF4vW
         ynnVdERwIigqKf8dKc9bb8vW8qDQd4kPtAdVnlONDon07K5R0WuyWmpWb2b2meD2vYDP
         aaKUZTGEfxOl05UkR8a8VV4k/bK+fn9qnnFvY=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: =?utf-8?q?J=C3=B6rg_Otte?= <jrg.otte@googlemail.com>
Subject: Re: v2.6.38-rc5 drm:radeon regression
Date: Mon, 21 Feb 2011 21:03:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <AANLkTi=6x93A11MzAjKyqO+7aP3t7QD8eMh7XVWp8GD6@mail.gmail.com>
In-Reply-To: <AANLkTi=6x93A11MzAjKyqO+7aP3t7QD8eMh7XVWp8GD6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102212103.40923.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=29632
for your bug report, please add your address to the CC list in there, thanks!

On piątek, 18 lutego 2011 o 12:47:56 Jörg Otte wrote:
> Reaching the desktop in v2.6.38-rc5 I only see the background.
> No Icon,widgets,windows etc. I am under the impression
> that everything is there - but invisible.
> 
> HW is Thinkpad T43 with Mobility Radeon X300 graphic.
> 
> Switching to the command line I see drm:radeon
> displaying permanently :
> drm:radeon_cs_ioctl          error invalid command stream
> drm:r100_cd_track_check  no buffer for AA resolve buffer
> 
> I bisected the problem to:
> 
> fff1ce4dc6113b6fdc4e3a815ca5fd229408f8ef is the first bad commit
> commit fff1ce4dc6113b6fdc4e3a815ca5fd229408f8ef
> Author: Marek Olšák <maraeo@gmail.com>
> Date:   Mon Feb 14 01:01:10 2011 +0100
> 
>     drm/radeon/kms: check AA resolve registers on r300
> 
>     This is an important security fix because we allowed arbitrary values
>     to be passed to AARESOLVE_OFFSET. This also puts the right buffer
> address in the register.
> 
>     Signed-off-by: Marek Olšák <maraeo@gmail.com>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> :040000 040000 c3a86a556f8c4ee1313bdc12e1f86cb44bacb742
> 
> 5b872a00532f36c0514790223375f1377a588501 M drivers

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
