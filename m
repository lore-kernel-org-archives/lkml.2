Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0CQMnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:43:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46722 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab0CQMm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xv18lD+oCa1vLrpBiNdg4IUzctjOnZYqoiwKLf7QeXSidFniOFGEKfuy7ScE/axTvx
         Eo0l1ZlskL8zGmBPM02fwPfSYSQQDczzxax2cYJg4qVPZ7jkEA8Xl5r9p0euajQnVJZk
         x3immU99weMKJHQ48NKTenV/LvYJg54v00yOw=
Message-ID: <4BA0CE4B.90508@gmail.com>
Date: Wed, 17 Mar 2010 23:42:51 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: x86 - Boot hangs at Calibrating delay loop on AMD SC520 
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I now have U-Boot booting 2.6.33 (abandoned 32-bit Boot Protocol and got a
pseudo BIOS working)

During boot I was getting a warning at arch/x86/kernel/rtc.c:125 and the
kernel hung at Calibrating delay loop... Also, all boot messages have a
zero time-stamp.

I have tried a 2.4.37.9 kernel and get the same freeze calibrating the
delay loop.

I have tried with and without the AMD Elan Extended (non-PC) x86 platform

I first assumed that the RTC is not working - I wasn't initially doing
anything relating to the SC520 RTC in U-Boot. I have added initialisation
code (as per the ÉlanTMSC520 Microcontroller User’s Manual Order #22004B)
and confirmed that the RTC is working in the SC520.

If traced back how the delay loop is performed and that has led me to
arch/x86/lib/delay.c where I promptly got very lost.

Any ideas?

