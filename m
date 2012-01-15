Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab2AOQhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 11:37:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:44118 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2AOQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 11:37:11 -0500
Date: Sun, 15 Jan 2012 17:37:04 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: Tree for Jan 9 (irqdomain.c)
Message-ID: <20120115163704.GB19026@linutronix.de>
References: <20120109170457.4465dfc66a0eace4a2230fef@canb.auug.org.au>
 <4F0B58B4.8010004@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F0B58B4.8010004@xenotime.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap | 2012-01-09 13:14:28 [-0800]:

>On 01/08/2012 10:04 PM, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20120106:
>> 
>> This tree is still broken for sparc64 defconfig (at least).
>
>
>  CC      kernel/irq/irqdomain.o
>In file included from arch/x86/include/asm/prom.h:24:0,
>                 from include/linux/of.h:139,
>                 from kernel/irq/irqdomain.c:5:
>arch/x86/include/asm/irq_controller.h:4:8: error: redefinition of 'struct irq_domain'

I just acked one of Rob's patches. I think this will be gone once his
patches goes in.

Sebastian
