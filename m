Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab0D3S0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:26:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:37854 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933191Ab0D3SZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:25:34 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/oPRla8UfoVTSZPw4OzROwuatbfzsI3MHuJPV247
	cgUDsB0UNgoD/Z
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arch/arm: Fix missing define for ARM_PMU_DEVICE_CPU
Date: Thu, 29 Apr 2010 12:18:46 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Jamie Iles <jamie.iles@picochip.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <201004290231.03440.PeterHuewe@gmx.de> <20100429081218.GA14783@wear.picochip.com> <1272529580.24662.10.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1272529580.24662.10.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004291218.46341.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 29 April 2010 10:26:20 schrieb Will Deacon:
> > This build error is due to the core patch of Will's "ARM: pmu: provide
> > a registration mechanism for IRQs" patch series not being merged yet.
> I submitted the series to Russell's patch system on 9 April.
> However, as you know, he's currently without an internet connection and
> the patch system has gone offline. 

Ah, didn't know about this - then sorry to 'bug' you with my patch :)
 
> Peter: if you're interested, the patch series I sent to the ARM
> Linux list is archived here:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/012113.html

Thanks for the Link - I'll have a look at it.


Thanks,
Peter

