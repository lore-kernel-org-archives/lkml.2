Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983Ab2DKTgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:36:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62765 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2DKTgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:36:07 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc1][Regression][suspend] suspend to disk does not power off laptop
Date: Wed, 11 Apr 2012 21:36:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc2; KDE/4.7.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201204021932.32205.maciej.rutecki@gmail.com>
In-Reply-To: <201204021932.32205.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204112136.02835.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 2 kwietnia 2012 o 19:32:32 Maciej Rutecki wrote:
> Last known good: 3.3
> Bad kernel: 3.4-rc1
> Subsystem: power management/suspend
> 
> When I try suspend to disk then kernel saves memory content to the disk,
> power of it,  but not power off whole machine. It hangs/stops on this
> screen:
> http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/DSC_5478.jpg
> 
> When I press power button then laptop power off. I still can resume (but
> hangs when restoring backlight state -- another bug, that I'm going to
> report).
> 
> Dmesg:
> http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/dmesg-3.4-rc1.txt
> 
> Config:
> http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/config-3.4.0-rc1
> 
> Regards

Seems be resolved in -rc2.

Thanks
-- 
Maciej Rutecki
http://www.mrutecki.pl
