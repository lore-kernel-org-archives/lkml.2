Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab2ATFQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 00:16:38 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35420 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2ATFQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 00:16:36 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f18f0a4c42917.06465691@nextmail.ru>
References: <NEXT-4f18f0a4c42917.06465691@nextmail.ru>
Date: Fri, 20 Jan 2012 10:46:35 +0530
Message-ID: <CAD2nsn2GjkoUWaDLxZmkxHm+af9s2fVkt8uGN+v-rS-hCgx2-w@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/1/20 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
>  > I read the roaming script. I need to get the scan results and then
> issue
>  > "roam" in loop between all the APs I can access, right? Will try just
> to
>  > collect some new testing data.
>  >
>  > Thanks for the patch - looks like it works fine so far.
>
> Got a fresh trace... No idea how it happened, to be honest.
>
> First, I got a few surprisingly non-lethal
>
> Jan 18 11:39:16 401a0bf1 kernel: [401292.709527] ath: Failed to stop TX
> DMA, queues=0x005!
> Jan 18 11:39:16 401a0bf1 kernel: [401292.726868] ath: Failed to stop TX
> DMA, queues=0x005!
>
> Jan 19 04:19:28 401a0bf1 kernel: [452270.295826] ath: Failed to stop TX
> DMA, queues=0x005!
> Jan 19 04:19:28 401a0bf1 kernel: [452270.313079] ath: Failed to stop TX
> DMA, queues=0x005!
>
> On Jan 19, I sshed quite a few gigabytes over cpio/ssh
>
> Got memory allocation warnings, log sample in the end of message. WiFi
> driver is mentioned in the stack, but looks mostly harmless.
>
> Then I suspended (succesfully) and when I got home I checked my email
> succesfully using WiFi.
>
> Then I did my standard mistake (closing the lid without stopping
> screensaver: after some time I get a GL screensaver with DPMS-Off state
> which is bad for i915 for some reason).
>
> I got failed GPU hangcheck at
>
> Jan 19 23:41:39 401a0bf1 kernel: [49726.973809]
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> and in two seconds X server was gone (I was asleep by that time)
>
> Then..
>
> Jan 20 06:37:41 401a0bf1 kernel: [74665.029637] ath: Timeout while waiting
> for nf to load: AR_PHY_AGC_CONTROL=0x40d22
> Jan 20 06:37:41 401a0bf1 kernel: [74665.362365] ath: Failed to stop TX
> DMA, queues=0x005!
> Jan 20 06:37:41 401a0bf1 kernel: [74665.371028] ------------[ cut here ]--
> ----------
> Jan 20 06:37:41 401a0bf1 kernel: [74665.371038] WARNING: at
> drivers/net/wireless/ath/ath9k/rc.c:697
> ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()

thanks , i am just looking at this tough to recreate warning and its
being reported by few users recently. please let us if you some more
information


-- 
shafi
