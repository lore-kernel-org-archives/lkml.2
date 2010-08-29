Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0H2NT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:19:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0H2NT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Q2+qm9pj6VVEfkf9xZuuqFHjZs/zN2aoskCW2IeurkDDT7wEu+1C0+ljWvHnQwwuRb
         AKQaIGc4WVFuGlgPZoToS/n7eCizh4uz/YYdId57PoA0w7Mt3+g5uVKFmxlR/640/baS
         UfokUFM+fnBmnjk1TInoDxNG4IUq2O0gpcwyI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tino Keitel <tino.keitel+xorg@tikei.de>
Subject: Re: 2.6.36-rc2 regression: Wrong screen resolution (1024x768 instead of 1680x1050)
Date: Sun, 29 Aug 2010 15:19:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <20100826073039.GA4567@mac.home>
In-Reply-To: <20100826073039.GA4567@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008291519.20734.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 26 sierpnia 2010 o 09:30:39 Tino Keitel wrote:
> Hi,
> 
> booting 2.6.36-rc2-git4 (commit
> d4348c678977c7093438bbbf2067c49396ae941b) results in a screen
> resolution of 1024x768 instead of 1680x1050.  It works fine with
> 2.6.35.2.
> 
> The framebuffer console uses the correct resolution, but only uses a
> part of the screen for text output. Xorg output looks distorted.
> 
> Xorg log is attached.
> 
> $ xrandr
> Screen 0: minimum 320 x 200, current 1024 x 768, maximum 4096 x 4096
> VGA1 disconnected (normal left inverted right x axis y axis)
> DVI1 connected 1024x768+0+0 (normal left inverted right x axis y axis)
> 454mm x 284mm
>    1680x1050      59.9 +
>    1280x1024      60.0
>    1280x960       60.0
>    1024x768       60.0*
>    800x600        60.3
>    640x480        60.0
>    720x400        70.1
> TV1 connected 1024x768+0+0 (normal left inverted right x axis y axis)
> 0mm x 0mm
>    848x480        30.0 +
>    640x480        30.0 +
>    1024x768       30.0*
>    800x600        30.0
> 
> This is a Mac mini Core 2 Duo with Intel i945 graphics.
> 

Seems be similar to:
https://bugzilla.kernel.org/show_bug.cgi?id=17301

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
