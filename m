Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab1FWRcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:32:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46996 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876Ab1FWRcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=D2JoJ4ngIHXImTF366IBs69Uv/kE92Gh1EKyO5HfHdexpuSBB2gESd65Izzjb3kFZA
         goh9gOsx3P9dNtseXbeeLIvn+gzQzkPqH3LPlzW0I5mbx1peX17V1z8G7mR7mzO8Z8hb
         0eynXsBhm0srtyj02Ojvtx5qHW1XYouJnufcg=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Meelis Roos <mroos@ut.ee>
Subject: Re: 3.0-rc3: No RTC device found
Date: Thu, 23 Jun 2011 19:32:03 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <alpine.SOC.1.00.1106081454240.8911@math.ut.ee> <alpine.SOC.1.00.1106141203350.11764@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1106141203350.11764@math.ut.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106231932.04258.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 14 czerwca 2011 o 11:06:49 Meelis Roos wrote:
> This was my earlier report that I tought was sparc64 specific:
> > Dmesg finds both OF RTC and PC RTC but later complains
> > "No RTC device found, ALARM timers will not wake from suspend"
> 
> But today I noticed this while testing 3.0-rc3 on a PC:
> 
> [    0.313944] No RTC device found, ALARM timers will not wake from suspend
> [    0.314275] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> 
> Later it detects PC RTC:
> 
> [    3.610210] rtc_cmos 00:03: RTC can wake from S4
> [    3.611554] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    3.611669] rtc0: alarms up to one year, y3k, 114 bytes nvram
> 
> Bisecting it on sparc64 got me nowhere. Have not tried bisecting it on
> PC yet.


I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=38092
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
