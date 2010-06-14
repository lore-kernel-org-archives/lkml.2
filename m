Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0FNOnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:43:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10456 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0FNOnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=jSvX3Ld3zRt+tdjfA0j4tSH9thPBi7N5h20I3Muh38xesi7hd1FIuGrGlEgQTi/zWy
         cspxQPpK2xxBZmgYZKTGx4gC9Mm0Gc4+d0NVruunxP2T55W0tsKncPnLaGFvBbMPcm/N
         dw0fYHl4LKVp7oWsmncVPhUQqw3oE84gAJP68=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tino Keitel <tino.keitel+xorg@tikei.de>
Subject: Re: Suspend hangs since 2.6.34
Date: Mon, 14 Jun 2010 16:42:56 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc3; KDE/4.3.4; i686; ; )
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20100609175356.GA17332@x61.home>
In-Reply-To: <20100609175356.GA17332@x61.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006141642.56802.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 9 czerwca 2010 o 19:53:56 Tino Keitel wrote:
> Hi,
> 
> as of kernel 2.6.34 I sometimes get a strange hang during suspend to
> RAM. After echo mem > /sys/power/state, the suspend script hangs, Xorg
> eats 100% CPU, and the desktop is frozen. I can kill the script and the
> computer will then suspend and resume fine. The kernel log shows
> nothing interesting when the hang happens:
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16207
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
