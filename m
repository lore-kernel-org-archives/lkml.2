Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1JHNA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:00:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1JHNA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:00:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Jason Chagas <jason.chagas@marvell.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 08/26] ARM: pxa: move z2 to generic cpu_suspend
Date: Sat, 08 Oct 2011 15:00:11 +0200
Message-ID: <14032344.tng7XWeaFg@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAMPhdO97bJZ1FRHUq_VHQ8oHyY7U4ay-jv5Ft+gunRwtBvz8qw@mail.gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <201110071156.38283.arnd@arndb.de> <CAMPhdO97bJZ1FRHUq_VHQ8oHyY7U4ay-jv5Ft+gunRwtBvz8qw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:m/TYo0FOAy3xkGzRNn4h8NC3U3kNMvDEOtqOAO2UfxG
 3NrnHIABMTKJ+or8uuXKA8bEGrey4p6i8EsbKVXZ5OTJnKLyhj
 QowDZRjzQ2xyPclp20Ivoh4HXvK8iws4lvntMO5Y1O2rWfCzz6
 R4ivZPUqVMv8MjzvayePmC8fIoIUUIi9ZYuU5yvsl3OEF4LyCI
 CkLBpM2rUp+OgC5eiad9XB579AQhte1eNTgbIqV0xfIFy/mtbi
 YXqF/qsF0i8pMy3vzC2S78PTISYPtHxIBmcEtZiFtLaWd/f8dX
 4s4syOZ0P+hUVwBUnnrIRloZOL1CjlHFoF+tL1IOxy0zWRCj85
 q6ItEroAOhDQRKtaXaKQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 October 2011 20:37:53 Eric Miao wrote:
> >>
> >>  #ifdef CONFIG_PM
> >> +extern void pxa27x_cpu_pm_enter(suspend_state_t state);
> >> +
> >>  static void z2_power_off(void)
> >>  {
> >>         /* We're using deep sleep as poweroff, so clear PSPR to ensure that
> >
> > You really shouldn't have an extern declaration in a .c file. Otherwise
> > looks good to me.
> 
> How about this one?

Yes, looks good as far as I can tell (I still don't quite understand how the
cpu power management all fits together, but I don't see anything wrong with
it either.

Acked-by: Arnd Bergmann <arnd@arndb.de>
