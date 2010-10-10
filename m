Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0JJRrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:47:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50636 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab0JJRrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=wR0YS6ERRWNb0LjchyWn/UnHUKqfNI+VOordY72s8RfYn6SIcXWbCoVm4LOkS/f70O
         paQGbB0yKLYH2nR9psnbxfVte83r8RKHCS4ZEqtyV67FWo2viz3b0rY3UFlcWrnjmhS4
         xCEtlOOFBcFJV72okIsyNvQrRbiWp6I7udcqk=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Dave Airlie <airlied@gmail.com>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Date: Sun, 10 Oct 2010 19:46:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
In-Reply-To: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010101946.53267.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 7 października 2010 o 10:55:15 Dave Airlie wrote:
> We are seeing this on both intel and radeon drivers when we reload the
> module with 2.6.36-rc7 or so, and we get no irqs for that device.
> 
> you can reproduce by
> 
> init 3
> echo 0 > /sys/class/vtconsole/vtcon1/bind
> rmmod i915
> modprobe i915
> 
> or radeon.
> 
> It seems to be possibly MSI related.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=20022
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
