Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab1ANR6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:58:46 -0500
Received: from smtp205.alice.it ([82.57.200.101]:55065 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab1ANR6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:58:41 -0500
From: Alberto Mattea <alberto@mattea.info>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Size difference in Kernel Modules
Date: Fri, 14 Jan 2011 18:58:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-020637-generic; KDE/4.5.5; x86_64; ; )
References: <AANLkTi=DU3MpNd4-7a3-n2E3voPk25AtwdL93SxGcvn8@mail.gmail.com>
In-Reply-To: <AANLkTi=DU3MpNd4-7a3-n2E3voPk25AtwdL93SxGcvn8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101141858.36264@alby>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data venerdì 14 gennaio 2011 18:47:41, anil joshi ha scritto:
> I have compiled kernel 2.6.35 but there is huge difference in size
> between 2.6.35.6-45.fc14.i686 (fedora core 14 ) and  compiled one
> I am using same configuration file as fc14 uses
> 
> following details show difference in size
> 
> 
> [Anil@localhost linux-2.6.35]$ du -h
> /lib/modules/2.6.35.6-45.fc14.i686/kernel/drivers/video/backlight/lcd.ko
> 8.0K
> /lib/modules/2.6.35.6-45.fc14.i686/kernel/drivers/video/backlight/lcd.ko
> [Anil@localhost linux-2.6.35]$ du -h
> /lib/modules/2.6.35/kernel/drivers/video/backlight/lcd.ko
> 160K /lib/modules/2.6.35/kernel/drivers/video/backlight/lcd.ko
> [Anil@localhost linux-2.6.35]$
> 
> 
> 62M /lib/modules/2.6.35.6-45.fc14.i686/
> 
> 587M /lib/modules/2.6.35/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Usually when this happens to me it is because debugging symbols are included 
in the build. Are you sure the configuration file has them disabled? On Ubuntu, 
for instance, the configuration file which is described as the same used by 
kernel packagers actually has debugging enabled.

Alberto
